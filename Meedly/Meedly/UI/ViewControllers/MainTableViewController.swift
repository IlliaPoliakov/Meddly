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
  
  
  @IBAction func cleanData(_ sender: Any) {
    getFeedGroupsUseCase.cleanData()
    viewDidLoad()
  }
  
  // -MARK: - Properties -
  
  lazy var mainTableView: MainTableView = AppDelegate.DIContainer.resolve(MainTableView.self)!
  var updateState: UpdateState = .initialUpdate
  

  // -MARK: - Dependencies -
  
  private let getFeedGroupsUseCase: GetFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetFeedGroupsUseCase.self)!
  private let markAsReadedUseCase: MarkAsReadedUseCase =
  AppDelegate.DIContainer.resolve(MarkAsReadedUseCase.self)!
  
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainTableView.tableView = tableView
    
    tableView.dataSource = mainTableView.dataSource
    tableView.delegate = mainTableView
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
    
    updateGroups(updateState: updateState) { [weak self] newGroups in
      self?.mainTableView.groups = newGroups
      self?.mainTableView.configureInitialSnapshot(withGroups: newGroups)
      
      self?.updateState = .regularUpdate
    }
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
      let feedItem: FeedItem
      
      if mainTableView.presentationType == "Show All" {
        feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
        destinaitonVC.item = feedItem
      }
      else {
        feedItem = mainTableView.allItems![selectedIndex!.row]
        destinaitonVC.item = feedItem
      }
      
      let groupIndex = mainTableView.groups?.firstIndex {
        $0.items != nil && $0.items!.contains(feedItem)
      }
      let itemIndex = mainTableView.groups![groupIndex!]
        .items!.firstIndex(of: mainTableView.allItems![selectedIndex!.row])
      
      mainTableView.groups![groupIndex!].items![itemIndex!].isViewed = true
      
      tableView.cellForRow(at: selectedIndex!)?.contentView.alpha = 0.5
//      markAsReadedUseCase.execute(forFeedItem: feedItem)
      
      
    case "itemDescriptionWIthoutImageId":
      guard let destinaitonVC = segue.destination as? ItemDescriptinViewConrtollerWithoutImage
      else {
        return
      }
      
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem: FeedItem
      
      if mainTableView.presentationType == "Show All" {
        feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
        destinaitonVC.item = feedItem
        
        mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row].isViewed = true
      }
      else {
        feedItem = mainTableView.allItems![selectedIndex!.row]
        destinaitonVC.item = feedItem

        mainTableView.allItems![selectedIndex!.row].isViewed = true
      }
      
      tableView.cellForRow(at: selectedIndex!)?.contentView.alpha = 0.5
      markAsReadedUseCase.execute(forFeedItem: feedItem)
      
    case "SortVCSegueId":
      guard let destinaitonVC = segue.destination as? SortViewController
      else {
        return
      }
      let groupNames = self.mainTableView.groups?.map { $0.title }
      if groupNames != nil {
        for groupName in groupNames! {
          destinaitonVC.groups.append(groupName)
        }
      }
      
    default:
      break
    }
  }
    
  @IBAction func unwind( _ segue: UIStoryboardSegue) {
    switch segue.identifier {
    case "unwindToMain":
      guard let previousVC = segue.source as? AddFeedViewController
      else {
        fatalError("Can't perform segue from AddVC")
      }
      
      let newAddGroups = previousVC.newGroups
      
      mainTableView.addNewGroups(withNewGroups: newAddGroups)
      
      updateGroups(updateState: .regularUpdate) { [weak self] newGroups in
        self?.mainTableView.groups = newGroups
        self?.mainTableView.updatePresentation()
      }
      
    case "unwindFromSort":
      guard let previousVC = segue.source as? SortViewController
      else {
        fatalError("Can't perform segue from AddVC")
      }
      
      let chosenPresenationType = previousVC.chosenPresentationType
      
      self.mainTableView.presentationType = chosenPresenationType
      self.mainTableView.updatePresentation()
      
      switch chosenPresenationType {
      case "Show All":
        self.title = "All Your Posts"
        
      case "New First":
        self.title = "Fresh Posts"
          
      case "Old First":
        self.title = "Old Posts"
            
      case "Unread Only":
        self.title = "Unread Posts"
            
      default:
        self.title = chosenPresenationType
      }
      
    default:
      break
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
  
  @IBAction func update(_ sender: Any) {
    updateGroups(updateState: .regularUpdate) { [weak self] newGroups in
      self?.mainTableView.groups = newGroups
      self?.mainTableView.updatePresentation()
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
