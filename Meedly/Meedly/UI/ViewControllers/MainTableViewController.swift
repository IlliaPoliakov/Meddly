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
  
  
  private var groups: [FeedGroupEntity]?
  
  private let getCachedFeedGroupsUseCase: GetCachedFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetCachedFeedGroupsUseCase.self)!
  
  private let getLoadedFeedGroupsUseCase: GetLoadedFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetLoadedFeedGroupsUseCase.self)!
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = dataSource
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension // for dynamic cell hight
    tableView.estimatedRowHeight = 600
    
    groups = getCachedFeedGroupsUseCase.execute()
    configureInitialSnapshot()
    
    update()
    
  }
  
  
  // -MARK: - Maintain table view -
  
  private lazy var dataSource: UITableViewDiffableDataSource<String, FeedItemEntity>  =  UITableViewDiffableDataSource<String, FeedItemEntity> (tableView: tableView) {
    tableView, indexPath, itemIdentifier in
    
    guard let item = self.groups?[indexPath.section].items?[indexPath.row]
            as? FeedItemEntity
    else {
      return nil
    }
    
    if item.imageData != nil {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCell")
              as? MainTableViewControllerCustomCell
      else {
        fatalError("Can't deque custom cell in MainVC.")
      }
      
      cell.bind(withFeedItem: item)
      
      return cell
    }
    else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCellWithoutText")
              as? MainVCCustomCellWithoutText
      else {
        fatalError("Can't deque custom cell in MainVC.")
      }
      
      cell.bind(withFeedItem: item)
      
      return cell
    }
  }
  
  func configureInitialSnapshot(){
    
    var snapshot = NSDiffableDataSourceSnapshot<String, FeedItemEntity>()
    
    guard groups != nil
    else {
      dataSource.apply(snapshot, animatingDifferences: true)
      return
    }
    
    for group in groups! {
      snapshot.appendSections([group.title])
      
      if group.items != nil && !(group.items!.isEmpty){
        snapshot.appendItems(group.items!, toSection: group.title)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateSnapshot(){
    
    var snapshot = dataSource.snapshot()
    
    guard groups != nil
    else {
      dataSource.apply(snapshot, animatingDifferences: true)
      return
    }
    
    for group in groups! {
      if group.items != nil && !(group.items!.isEmpty){
        snapshot.appendItems(group.items!, toSection: group.title)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func addNewSections(withNewGroupNames names: [String]?) {
    var snapshot = dataSource.snapshot()
    
    guard names != nil
    else {
      return
    }
    
    snapshot.appendSections(names!)
    
    dataSource.apply(snapshot)
  }
  
 
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAddVC",
       let destinaitonVC = segue.destination as? AddFeedViewController {
      destinaitonVC.groups = groups
    }
    else if segue.identifier == "descriptionSegueID",
       let destinaitonVC = segue.destination as? ItemDescriptinViewConrtoller {
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem = groups![selectedIndex!.section].items![selectedIndex!.row]
      
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
    
    if newSections != nil {
      addNewSections(withNewGroupNames: newSections)
      update()
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
    update()
  }
  
  
  // -MARK: - Supplementary -
  
  func update(){
    getLoadedFeedGroupsUseCase.execute() { [weak self] loadedGroups, errorMessage in
      if loadedGroups != nil && loadedGroups != self?.groups {
        self?.groups = loadedGroups
        self?.updateSnapshot()
      }
      
      if errorMessage != nil {
        print("'\(errorMessage!)' occurred when downloading data.")
      }
      
    }
  }
  
}
