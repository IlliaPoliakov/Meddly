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
  lazy var allItems: [FeedItem]? = groups?.flatMap { $0.items != nil ? $0.items! : [FeedItem]() }
  var presentationType: String = "Show All"
  
  lazy var dataSource: UITableViewDiffableDataSource<FeedGroup, FeedItem> =  UITableViewDiffableDataSource<FeedGroup, FeedItem> (tableView: tableView) {
    tableView, indexPath, itemIdentifier in
    
    var item: FeedItem? = nil
    
    switch self.presentationType {
    case "Show All":
      item = self.groups?[indexPath.section].items?[indexPath.row]
      
    case "New First", "Old First", "Unread Only" :
      item = self.allItems![indexPath.row]
      
    default:
      let chosenGroup = self.groups!.filter { $0.title == self.presentationType }
      item = chosenGroup.first!.items![indexPath.row]
    }
    
    guard item != nil
    else {
      return UITableViewCell()
    }
    
    if item!.imageUrl != nil {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCell")
              as? MainTableViewControllerCustomCell
      else {
        fatalError("Can't deque custom cell in MainVC.")
      }
      
      cell.bind(withFeedItem: item!)
      
      return cell
    }
    else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCustomCellWithoutText")
              as? MainVCCustomCellWithoutText
      else {
        fatalError("Can't deque custom cell in MainVC.")
      }
      
      cell.bind(withFeedItem: item!)
      
      if item!.isViewed == true {
        cell.alpha = 1
      }
      
      return cell
    }
  }
  

  init(tableView: UITableView, groups: [FeedGroup]?) {
    self.tableView = tableView
    self.groups = groups
  }
  
  
  // -MARK: - Functions -
  
  func configureInitialSnapshot(withGroups groups: [FeedGroup]?){
    var snapshot = NSDiffableDataSourceSnapshot<FeedGroup, FeedItem>()
    
    for group in groups! {
      snapshot.appendSections([group])
      
      if group.items != nil && !(group.items!.isEmpty){
        snapshot.appendItems(group.items!, toSection: group)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func getAllItems() -> [FeedItem]?{
    return groups?.flatMap { $0.items != nil ? $0.items! : [FeedItem]() }
  }
  
  func updateSnapshotWithItems(){
    
    guard allItems != nil,
          !(allItems!.isEmpty)
    else {
      return
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<FeedGroup, FeedItem>()
    let group = FeedGroup(feeds: nil, items: nil, id: UUID())
    snapshot.appendSections([group])
    snapshot.appendItems(allItems!, toSection: group)
    
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
  
  func updatePresentation(){
    allItems = getAllItems()
    
    switch presentationType {
    case "New First":
      if allItems != nil {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        let newItems = allItems!.sorted {
          formatter.date(from: $0.pubDate)! > formatter.date(from: $1.pubDate)!
        }
        
        allItems = newItems
        updateSnapshotWithItems()
      }
      
    case "Old First":
      if allItems != nil {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        let newItems = allItems!.sorted {
          formatter.date(from: $0.pubDate)! < formatter.date(from: $1.pubDate)!
        }
        
        allItems = newItems
        updateSnapshotWithItems()
      }
    
    case "Unread Only":
      if allItems != nil {
        let newItems = allItems!.filter { $0.isViewed == true }
        
        allItems = newItems
        updateSnapshotWithItems()
      }
      
    case "Show All":
      configureInitialSnapshot(withGroups: groups)
      
    default:
      let newGroup = groups?.filter { $0.title == presentationType }
      configureInitialSnapshot(withGroups: newGroup)
    }
  }

}
