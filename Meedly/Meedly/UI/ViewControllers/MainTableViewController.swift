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
  
  private let getCachedFeedGroupsUseCase: GetCachedFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetCachedFeedGroupsUseCase.self)!
  
  private let getLoadedFeedGroupsUseCase: GetLoadedFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetLoadedFeedGroupsUseCase.self)!
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainTableView.groups = getCachedFeedGroupsUseCase.execute()

    tableView.dataSource = mainTableView.dataSource
    tableView.delegate = mainTableView
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
    
    mainTableView.configureInitialSnapshot()
    
    update()
    
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
      
      destinaitonVC.titleString = feedItem.title
      destinaitonVC.descriptionText = feedItem.feedItemDescription
      destinaitonVC.link = feedItem.link
      
      if feedItem.imageData != nil {
        destinaitonVC.image = UIImage(data: feedItem.imageData!)
      }
    }
    
  }
    
  @IBAction func unwind( _ segue: UIStoryboardSegue) {
    guard segue.identifier == "unwindToMain",
          let previousVC = segue.source as? AddFeedViewController
    else {
      fatalError("Can't perform segue to AddVC")
    }
    
    let newSections = previousVC.newGroupNames
    
    mainTableView.addNewSections(withNewGroupNames: newSections)
    update()
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
    update()
  }
  
  
  // -MARK: - Supplementary -
  
  func update(){
    getLoadedFeedGroupsUseCase.execute() { [weak self] loadedGroups, errorMessage in
      if loadedGroups != nil && loadedGroups != self?.mainTableView.groups {
        self?.mainTableView.groups = loadedGroups
        self?.mainTableView.updateSnapshot()
      }
   
      if errorMessage != nil {
        print("'\(errorMessage!)' occurred when downloading data.")
      }
      
    }
  }
  
}
