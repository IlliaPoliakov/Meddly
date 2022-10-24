//
//  AddViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import Foundation
import UIKit
//import Swinject

class AddFeedViewController: UIViewController, UITableViewDelegate {
  
  // MARK: - IBOutlets -

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var urlTextField: UITextField!
  
  
  // MARK: - Properties -
  
  var newGroupNames: [String]?
  var selectedRowIndexPath: IndexPath? = nil
  var groups: [FeedGroupEntity]?
  
  private let saveNewGroupUseCase: SaveNewGroupUseCase =
  AppDelegate.DIContainer.resolve(SaveNewGroupUseCase.self)!
  
  private let saveNewFeedUseCase: SaveNewFeedUseCase =
  AppDelegate.DIContainer.resolve(SaveNewFeedUseCase.self)!
  
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = dataSource
    tableView.delegate = self
    
    self.hideKeyboardWhenTappedAround()
    
    configureInitialSnapshot()
  }
  
  
  // MARK: - Maintain table view -
  
  enum Section {
    case main
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRowIndexPath = indexPath
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    selectedRowIndexPath = nil
  }
  
  private lazy var dataSource: UITableViewDiffableDataSource<Section, String> = UITableViewDiffableDataSource(
    tableView: tableView) { tableView, indexPath, itemIdentifier in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell", for: indexPath)
      cell.backgroundColor = UIColor.clear
      
      guard let groupName = self.groups?[indexPath.row].title
      else {
        return cell
      }
      
      cell.textLabel?.text = groupName
      
      if self.selectedRowIndexPath == indexPath {
        cell.backgroundColor = UIColor.lightGray
      }
      
      return cell
    }
  
  func configureInitialSnapshot(){
    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.main])
    
    guard groups != nil
    else {
      dataSource.apply(snapshot, animatingDifferences: false)
      return
    }
    
    for group in groups! {
      snapshot.appendItems([group.title] , toSection: .main)
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateSnapshot(withNewGroupName name: String){
    var snapshot = dataSource.snapshot()
    
    snapshot.appendItems([name], toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  
  // MARK: - IBActions -
  
  @IBAction func createNewGroup(_ sender: Any) {
    
    let alert = UIAlertController(title: "New Group", message: "Enter a Group Name:", preferredStyle: .alert)
    alert.addTextField { _ in }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    let addAction = UIAlertAction(title: "Add", style: .default) { [self, weak alert] (_) in
      
      guard let groupName = alert!.textFields![0].text,
            groupName != ""
      else {
        print("Group Name Field is Empty!")
        return
      }
      
      guard !(self.groups?.contains(where: { $0.title == groupName }) ?? false)
      else {
        print("Group with given name already exist!")
        return
      }
      
      let newGroup = saveNewGroupUseCase.execute(withNewGroupName: groupName)
      
      if groups != nil {
        groups?.append(newGroup)
      }
      else {
        groups = [newGroup]
      }
      
      updateSnapshot(withNewGroupName: groupName)
      
      if newGroupNames == nil {
        newGroupNames = [groupName]
      }
      else {
        newGroupNames!.append(groupName)
      }
    }
    
    alert.addAction(cancelAction)
    alert.addAction(addAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func addNewFeed(_ sender: Any) {
    
    guard urlTextField.text != nil,
          !(urlTextField.text!.isEmpty)
    else {
      print("Field for url is empty!")
      return
    }
    
    guard let feedUrl = URL(string: urlTextField.text!)
    else {
      print("Please check your URL!")
      return
    }
    
    guard selectedRowIndexPath != nil
    else {
      print("Group for new feed wasn't selected!")
      return
    }
    
    for group in groups! {
      guard group.feeds != nil,
            !(group.feeds!.contains(where: { $0.link.description == urlTextField.text! }) )
      else {
        print("Given chanel already eaists in group \(group.title)!")
        
        return
      }
    }
    
    saveNewFeedUseCase.execute(withNewFeedUrl: feedUrl, withParentGroup:
                                groups![selectedRowIndexPath!.row])
    
    performSegue(withIdentifier: "unwindToMain", sender: self)
  }
  
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
