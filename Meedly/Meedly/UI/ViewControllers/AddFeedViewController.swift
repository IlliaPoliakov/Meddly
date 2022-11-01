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
  
  lazy var addFeedTableView: AddFeedTableView = AddFeedTableView(tableView: tableView, groups: groups)
  lazy var groups: [FeedGroup]? = nil
  
  var newGroups: [FeedGroup]? = nil
  
  private let saveNewGroupUseCase: SaveNewGroupUseCase =
  AppDelegate.DIContainer.resolve(SaveNewGroupUseCase.self)!
  
  private let saveNewFeedUseCase: SaveNewFeedUseCase =
  AppDelegate.DIContainer.resolve(SaveNewFeedUseCase.self)!
  
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = addFeedTableView.dataSource
    tableView.delegate = addFeedTableView
    
    self.hideKeyboardWhenTappedAround()
    
    addFeedTableView.configureInitialSnapshot()
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
      
      guard !(self.addFeedTableView.groups?.contains(
        where: { $0.title == groupName }) ?? false)
      else {
        print("Group with given name already exist!")
        return
      }
      
      let newGroup = saveNewGroupUseCase.execute(withNewGroupName: groupName)
      
      addFeedTableView.groups?.append(newGroup)
      
      addFeedTableView.updateSnapshot(withNewGroupName: groupName)
      
      if newGroups == nil {
        newGroups = [newGroup]
      }
      else {
        newGroups!.append(newGroup)
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
    
    guard addFeedTableView.selectedRowIndexPath != nil
    else {
      print("Group for new feed wasn't selected!")
      return
    }
    
    for group in addFeedTableView.groups! {
      guard group.feeds != nil,
            !(group.feeds!.contains(where: { $0.link.description == urlTextField.text! }) )
      else {
        print("Given chanel already exists in group \(group.title)!")
        
        return
      }
    }
    
    saveNewFeedUseCase.execute(withNewFeedUrl: feedUrl, withParentGroup:
                                addFeedTableView.groups![addFeedTableView.selectedRowIndexPath!.row])
    
    performSegue(withIdentifier: "unwindToMain", sender: self)
  }
  
}


// -MARK: - Extensions -

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

extension AddFeedViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == urlTextField {
      return textField.becomeFirstResponder()
    } else {
      return textField.resignFirstResponder()
    }
  }
}
