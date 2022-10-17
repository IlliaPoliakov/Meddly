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
  
  let getGroupsUseCase: GetFeedsUseCase = GetFeedsUseCase(
    repo: FeedGroupsRepositoryImpl(
      localDataSource: FeedsDataBaseDataSource(),
      remoteDataSource: FeedsNetworkDataSource()
    )
  )
  
  var groups: [Group]?
  
  private lazy var dataSource: UITableViewDiffableDataSource<String, Feed> = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCell")
            as? MainTableViewControllerCustomCell
    else {
      fatalError("Can't deque custom cell in MainVC.")
    }
    cell.updateData(withFeed: groups[indexPath.section].ch)
  }
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = dataSource
    
    tableView.rowHeight = UITableView.automaticDimension // for dynamic cell hight
    tableView.estimatedRowHeight = 600
    
    groups = getGroupsUseCase.execute()
    // set coresponding tableView title
  }
  
  
  // MARK: - Maintain table view -
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return groups?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let chanels = groups?[section].chanels
    else {
      return 0
    }
    
    var amountOfFeeds = 0
    for chanel in chanels {
      amountOfFeeds += chanel.feeds.count
    }
    return amountOfFeeds
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "showAddVC",
          let destinaitonVC = segue.destination as? AddViewController
    else {
      fatalError("Can't perform segue to AddVC")
    }
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
