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
  
  var selectedRowIndexPath: IndexPath?
  var groups: [Group]?
  
  private lazy var dataSource: UITableViewDiffableDataSource<Int, String> = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell", for: indexPath)
    cell.backgroundColor = UIColor.clear
    
    guard let groupName = self.groups?[indexPath.row].title
    else {
      return cell
    }
    
    cell.textLabel!.text = groupName
    
    if self.selectedRowIndexPath == indexPath {
      cell.backgroundColor = UIColor.lightGray
    }
    
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource
    
    configureInitialSnapshot()
  }
  
  // MARK: - Maintain table view -
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if(selectedRowIndexPath != nil) {
      guard let prevSelectedCell = tableView.cellForRow(at: selectedRowIndexPath!)
      else {
        fatalError("can't perform cell selection")
      }
      prevSelectedCell.backgroundColor = UIColor.clear
    }
    
    guard let selectedCell = tableView.cellForRow(at: indexPath)
    else {
      fatalError("can't perform cell selection")
    }
    
    selectedCell.backgroundColor = UIColor.lightGray
    selectedRowIndexPath = indexPath
  }
  
  func updateSnapshot(forNewGroup groupName: String){
    var snapshot = dataSource.snapshot()
    snapshot.appendItems([groupName], toSection: 1)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func configureInitialSnapshot(){
    var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
    snapshot.appendSections([1])
    
    if groups != nil {
      for group in groups! {
        snapshot.appendItems([group.title], toSection: 1)
      }
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  // MARK: - IBActions -
  
  @IBAction func addNewChanel(_ sender: Any) {
  }
  
  @IBAction func createNewGroup(_ sender: Any) {
    let alert = UIAlertController(title: "New Group", message: "Enter a Group Name:", preferredStyle: .alert)
    alert.addTextField { _ in }
    alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak alert] (_) in
      guard let groupName = alert!.textFields![0].text
      else {
        let alert = UIAlertController(title: "Oops...",
                                      message: "Group with given Name already exists:",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fuck!!", style: .default) { _ in })
        self.present(alert, animated: true, completion: nil)
        return
      }
      
      guard !(self.groups?.contains(where: {$0.title == groupName}) ?? false)
      else {
        let alert = UIAlertController(title: "Oops...",
                                      message: "Group with given Name already exists:",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fuck!!", style: .default) { _ in })
        self.present(alert, animated: true, completion: nil)
        return
      }
      self.updateSnapshot(forNewGroup: groupName)
      self.groups?.append(Group())
    })
    
    
    
    self.present(alert, animated: true, completion: nil)
  }
}
