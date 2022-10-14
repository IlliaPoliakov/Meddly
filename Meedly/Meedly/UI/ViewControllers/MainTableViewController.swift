//
//  MainTableViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import UIKit

class MainTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
  }
  
  // MARK: - Maintain table view -
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 50
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "mainVCCustomCell") as? MainTVCConvinientCell
    else {
      fatalError("Can't deque custom cell in MainTVC.")
    }
    
    
    return cell
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "showAddVC",
          let destinaitonVC = segue.destination as? AddViewController
    else {
      fatalError("Can't perform segue to AddVC")
    }
    
    
    // set addvc code here
  }
  
  // MARK: - IBActions -
  
  @IBAction func checkActivity(_ sender: Any) {
  }
  
  @IBAction func configureTypeOfPresentation(_ sender: Any) {
  }
  
  @IBAction func markAsReaded(_ sender: Any) {
  }
  @IBAction func showSideBar(_ sender: Any) {
  }
  @IBAction func sortPresentation(_ sender: Any) {
  }
}
