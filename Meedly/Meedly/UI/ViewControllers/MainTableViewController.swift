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
  
  let getGroupsUseCase: GetFeedGroupsUseCase = GetFeedGroupsUseCase(
    repo: FeedGroupsRepositoryImpl(
      localDataSource: FeedGroupsDataBaseDataSource(),
      remoteDataSource: FeedGroupsNetworkDataSource()
    )
  )
  
  var groups: [Group]?
  
  private lazy var dataSource: UITableViewDiffableDataSource<String, Feed> = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCell")
            as? MainTableViewControllerCustomCell
    else {
      fatalError("Can't deque custom cell in MainVC.")
    }
    
    guard let feed = self.groups?[indexPath.section].feeds?[indexPath.row]
    else {
      return cell
    }
    cell.updateData(withFeed: feed)
    
    return cell
  }
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    groups = getGroupsUseCase.execute()
    groups = nil
    
    tableView.dataSource = dataSource
    
    tableView.rowHeight = UITableView.automaticDimension // for dynamic cell hight
    tableView.estimatedRowHeight = 600
    
    
    
  }
  
  
  // MARK: - Maintain table view -
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return groups?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups?[section].feeds?.count ?? 0
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
}
