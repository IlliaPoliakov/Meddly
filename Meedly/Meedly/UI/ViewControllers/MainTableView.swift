//
//  MainTableView.swift
//  Meedly
//
//  Created by Illia Poliakov on 29.10.22.
//

import UIKit

class MainTableView: NSObject, UITableViewDelegate {

  var tableView: UITableView
  var groups: [FeedGroupEntity]?
  
  init(tableView: UITableView, groups: [FeedGroupEntity]?) {
    self.tableView = tableView
    self.groups = groups
  }
  

  lazy var dataSource: UITableViewDiffableDataSource<String, FeedItemEntity> =  UITableViewDiffableDataSource<String, FeedItemEntity> (tableView: tableView) {
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
  
 

}
