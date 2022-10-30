//
//  MainTableViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
  
  // -MARK: - Properties -
  
  lazy var mainTableView = MainTableView(tableView: tableView, groups: nil)
  

  // -MARK: - Dependencyes _
  
  private let getFeedGroupsUseCase: GetFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetFeedGroupsUseCase.self)!
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateGroups()
    mainTableView.configureInitialSnapshot()
    
    tableView.dataSource = mainTableView.dataSource
    tableView.delegate = mainTableView
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
    
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAddVC",
       let destinaitonVC = segue.destination as? AddFeedViewController {
      
      destinaitonVC.groups = mainTableView.groups
      
    }
    else if segue.identifier == "descriptionSegueID",
       let destinaitonVC = segue.destination as? ItemDescriptinViewConrtoller {
      
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
      
      destinaitonVC.item = feedItem
    }
  }
    
  @IBAction func unwind( _ segue: UIStoryboardSegue) {
    guard segue.identifier == "unwindToMain",
          let previousVC = segue.source as? AddFeedViewController
    else {
      fatalError("Can't perform segue to AddVC")
    }
    
    let newGroups = previousVC.newGroups
    
    mainTableView.addNewGroups(withNewGroups: newGroups)
    
    updateGroups()
    mainTableView.updateSnapshot()
  }
  
  
  // MARK: - IBActions -
  
  @IBAction func showSideBar(_ sender: Any) {
    
  }
  
  @IBAction func checkActivity(_ sender: Any) {
    
  }
  
  @IBAction func configureTypeOfPresentation(_ sender: Any) {
    
  }
  
  @IBAction func markAsReaded(_ sender: Any) {
    
  }
  
  @IBAction func sortPresentation(_ sender: Any) {
    
  }
  
  @IBAction func update(_ sender: Any) {
    updateGroups()
    mainTableView.updateSnapshot()
  }
  
  
  // -MARK: - Supplementary -
  
  func updateGroups(){
    getFeedGroupsUseCase.execute() { [weak self] loadedGroups, errorMessage in
      if loadedGroups != self?.mainTableView.groups {
        self?.mainTableView.groups = loadedGroups
      }
   
      if errorMessage != nil {
        print("'\(errorMessage!)' occurred when downloading data.")
      }
      
    }
  }
  
}
