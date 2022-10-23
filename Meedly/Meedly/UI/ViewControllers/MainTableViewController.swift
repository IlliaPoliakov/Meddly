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
  
  var groups: [Group]?
  
  let getFeedGroupsUseCase: GetFeedGroupsUseCase = GetFeedGroupsUseCase(
    repo: GetFeedGroupsRepositoryImpl(
      localDataSource: FeedGroupsDataBaseDataSource(),
      remoteDataSource: FeedGroupsNetworkDataSource()
    )
   )
  
  
  // -MARK: - LifeCycle -
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    groups = getFeedGroupsUseCase.execute()
    groups == nil ? print("NIL"): print("NOTNIL")
    tableView.dataSource = dataSource
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension // for dynamic cell hight
    tableView.estimatedRowHeight = 600
    
    configureInitialSnapshot()
  }
  
  
  // -MARK: - Maintain table view -
  
  private lazy var dataSource: UITableViewDiffableDataSource<String, Feed>  =  UITableViewDiffableDataSource<String, Feed> (tableView: tableView) { tableView, indexPath, itemIdentifier in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCell")
            as? MainTableViewControllerCustomCell
    else {
      fatalError("Can't deque custom cell in MainVC.")
    }
    
    guard let feed = self.groups?[indexPath.section].feeds?[indexPath.row] as? Feed
    else {
      return cell
    }
    cell.updateData(withFeed: feed)
    
    return cell
  }
  
  func configureInitialSnapshot(){
    var snapshot = NSDiffableDataSourceSnapshot<String, Feed>()
    guard groups != nil
    else {
      dataSource.apply(snapshot, animatingDifferences: true)
      return
    }
    
    for group in groups! {
      snapshot.appendSections([group.title])
      
      if group.feeds != nil {
        if !(group.feeds!.isEmpty) {
          snapshot.appendItems(group.feeds!, toSection: group.title)
        }
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func updateSnapshot(){

    var snapshot = dataSource.snapshot()
    
    guard groups != nil
    else {
      dataSource.apply(snapshot, animatingDifferences: true)
      return
    }
    
    for group in groups! {
      if group.feeds != nil {
        snapshot.appendItems(group.feeds!, toSection: group.title)
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
 
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return groups![section].title
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "showAddVC",
          let destinaitonVC = segue.destination as? AddViewController
    else {
      fatalError("Can't perform segue to AddVC")
    }
    destinaitonVC.groups = groups
  }
  
  @IBAction func unwind( _ segue: UIStoryboardSegue) {
    guard segue.identifier == "unwindToMain",
          let previousVC = segue.source as? AddViewController
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
    if Reachability.isConnectedToNetwork(){
      groups = getFeedGroupsUseCase.execute()
      updateSnapshot()
    }
    else{
      print("Internet Connection not Available!")
    }
  }
}
