//
//  AddViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import Foundation
import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - Properties -
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var urlTextField: UITextField!
  
  var selectedRowIndexPath: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - Maintain table view -
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 200
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell", for: indexPath)
    cell.backgroundColor = UIColor.clear
    cell.textLabel!.text = "JOPAAAA"
    
    if selectedRowIndexPath == indexPath {
      cell.backgroundColor = UIColor.lightGray
    }
    
    return cell
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
  
  // MARK: - IBActions -
  
  @IBAction func createNewGroup() {
    let alert = UIAlertController(title: "New Group", message: "Enter a Group Title:", preferredStyle: .alert)
    alert.addTextField { _ in }
    alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak alert] (_) in
      let textField = alert!.textFields![0]
    
    })

    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func addChanel() {
    
  }
}
