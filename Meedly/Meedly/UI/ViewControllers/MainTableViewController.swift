//
//  MainTableViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import UIKit

enum UpdateState {
  case initialUpdate
  case regularUpdate
}

class MainTableViewController: UITableViewController {
  
  // -MARK: - Properties -
  
  lazy var mainTableView: MainTableView = AppDelegate.DIContainer.resolve(MainTableView.self)!
  var updateState: UpdateState = .initialUpdate
  

  // -MARK: - Dependencies -
  
  private let getFeedGroupsUseCase: GetFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetFeedGroupsUseCase.self)!
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainTableView.tableView = tableView
    
    updateGroups(updateState: updateState) { [weak self] newGroups in
      if self?.updateState == .initialUpdate {
        self?.mainTableView.configureInitialSnapshot(withGroups: newGroups)
        self?.updateState = .regularUpdate
      }
      else {
        self?.mainTableView.updateSnapshot(withGroups: newGroups)
      }
    }
      
    tableView.dataSource = mainTableView.dataSource
    tableView.delegate = mainTableView
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
    
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showAddVC":
      guard let destinaitonVC = segue.destination as? AddFeedViewController
      else {
        return
      }
      
      destinaitonVC.groups = mainTableView.groups
      
    case "descriptionSegueID" :
      guard let destinaitonVC = segue.destination as? ItemDescriptinViewConrtoller
      else {
        return
      }
      
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
      
      destinaitonVC.item = feedItem
    case "itemDescriptionWIthoutImageId":
      guard let destinaitonVC = segue.destination as? ItemDescriptinViewConrtollerWithoutImage
      else {
        return
      }
      
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
      
      destinaitonVC.item = feedItem
    default:
      break
    }
  }
    
  @IBAction func unwind( _ segue: UIStoryboardSegue) {
    guard segue.identifier == "unwindToMain",
          let previousVC = segue.source as? AddFeedViewController
    else {
      fatalError("Can't perform segue from AddVC")
    }
    
    let newAddGroups = previousVC.newGroups
    
    mainTableView.addNewGroups(withNewGroups: newAddGroups)
    
    updateGroups(updateState: .regularUpdate) { [weak self] newGroups in
      self?.mainTableView.updateSnapshot(withGroups: newGroups)
    }
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
    updateGroups(updateState: .regularUpdate) { [weak self] newGroups in
      self?.mainTableView.updateSnapshot(withGroups: newGroups)
    }
  }
  
  
  // -MARK: - Supplementary -
  
  func updateGroups(updateState state: UpdateState, _ completion: @escaping ([FeedGroup]?) -> Void){
    getFeedGroupsUseCase.execute(updateState: state) { loadedGroups, errorMessage in
      
      completion(loadedGroups)
   
      if errorMessage != nil {
        print("'\(errorMessage!)' occurred when downloading data.")
      }
    }
  }
  
}
