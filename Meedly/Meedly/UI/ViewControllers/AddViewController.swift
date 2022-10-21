//
//  AddViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import Foundation
import UIKit
import CoreData

class AddViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var urlTextField: UITextField!
  
  var newGroupNames: [String]?
  var selectedRowIndexPath: IndexPath?
  var groups: [Group]? = nil
  var saveNewGroupNameUseCase: SaveNewGroupUseCase = SaveNewGroupUseCase(
    repo: SaveNewGroupRepositoryImpl(
      localDataSource: FeedGroupsDataBaseDataSource()
    )
  )
  var saveNewChanelUseCase: SaveNewChanelUseCase = SaveNewChanelUseCase(
    repo: SaveNewChanelRepositoryImpl(
      localDataSource: FeedGroupsDataBaseDataSource()
    )
  )
  
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource
    
    configureInitialSnapshot()
  }
  
  
  // MARK: - Maintain table view -
  
  enum Section {
    case main
  }
  
  private lazy var dataSource: UITableViewDiffableDataSource<Section, String> = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
    
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
    
    if groups != nil {
      var counter = 0
      for group in groups! {
        print("JOPA \(counter)")
        counter += 1
        snapshot.appendItems([group.title] , toSection: .main)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateSnapshot(forNewGroup groupName: String){
    var snapshot = dataSource.snapshot()
    snapshot.appendItems([groupName], toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  
  // MARK: - IBActions -
  
  @IBAction func addNewChanel(_ sender: Any) {
    guard urlTextField.text != nil
    else {
      print("Field for url is empty!")
      return
    }
    
    guard let newChanelUrl = URL(string: urlTextField.text!)
    else {
      print("Please check your URL!")
      return
    }
    
    guard selectedRowIndexPath != nil
    else {
      print("Group for url wasn't selected!")
      return
    }
    
    for group in groups! {
      if group.chanels != nil {
        if group.chanels!.contains(where: { $0.link.description == urlTextField.text! } ) {
          print("Given chanel already eaists in group \(group)!")
          return
        }
      }
    }
    
    saveNewChanelUseCase.execute(newChanelUrl, groups![selectedRowIndexPath!.row])
    
    performSegue(withIdentifier: "unwindToMain", sender: self)
  }
  
  @IBAction func createNewGroup(_ sender: Any) {
    let alert = UIAlertController(title: "New Group", message: "Enter a Group Name:", preferredStyle: .alert)
    alert.addTextField { _ in }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    let addAction = UIAlertAction(title: "Add", style: .default) { [self, weak alert] (_) in
      guard let groupName = alert!.textFields![0].text,
            groupName != ""
      else {
        print("Group Name Feld is Empty!")
        return
      }
      
      guard !(self.groups?.contains(where: { $0.title == groupName }) ?? false)
      else {
        print("Group with given name already exist!")
        return
      }
      
      self.updateSnapshot(forNewGroup: groupName)
      
      let newGroup = saveNewGroupNameUseCase.execute(groupName)
      groups?.append(newGroup)
      
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
}
