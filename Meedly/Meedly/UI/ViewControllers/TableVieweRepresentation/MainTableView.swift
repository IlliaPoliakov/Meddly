//
//  MainTableView.swift
//  Meedly
//
//  Created by Illia Poliakov on 29.10.22.
//

import UIKit

class MainTableView: NSObject, UITableViewDelegate {
  
  // -MARK: - Properties -
  
  var tableView: UITableView
  var groups: [FeedGroup]?
  
  lazy var dataSource: UITableViewDiffableDataSource<FeedGroup, FeedItem> =  UITableViewDiffableDataSource<FeedGroup, FeedItem> (tableView: tableView) {
    tableView, indexPath, itemIdentifier in
    
    guard let item = self.groups?[indexPath.section].items?[indexPath.row]
            as? FeedItem
    else {
      return UITableViewCell()
    }
    
    if item.imageUrl != nil {
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
  

  init(tableView: UITableView, groups: [FeedGroup]?) {
    self.tableView = tableView
    self.groups = groups
  }
  
  
  // -MARK: - Functions -
  
  func configureInitialSnapshot(withGroups groups: [FeedGroup]?){
    self.groups = groups
    
    var snapshot = NSDiffableDataSourceSnapshot<FeedGroup, FeedItem>()
    
    for group in groups! {
      snapshot.appendSections([group])
      
      if group.items != nil && !(group.items!.isEmpty){
        snapshot.appendItems(group.items!, toSection: group)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateSnapshot(withGroups newGroups: [FeedGroup]?){
    guard newGroups != nil
    else {
      return
    }
    
    var snapshot = dataSource.snapshot()
    
    for i in 0 ..< newGroups!.count {
      let diffItems = self.groups![i].items?.difference(from: newGroups![i].items!)
      
      if diffItems != nil {
        snapshot.appendItems(diffItems!, toSection: self.groups![i])
      }
    }
    
    self.groups = newGroups
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func addNewGroups(withNewGroups newGroups: [FeedGroup]?) {
    var snapshot = dataSource.snapshot()
    
    guard newGroups != nil
    else {
      return
    }
    
    for group in newGroups! {
      self.groups!.append(group)
    }
    snapshot.appendSections(newGroups!)
    
    dataSource.apply(snapshot)
  }
  
 

}
