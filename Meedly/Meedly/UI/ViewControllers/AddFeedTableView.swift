//
//  MainTableView.swift
//  Meedly
//
//  Created by Illia Poliakov on 29.10.22.
//

import UIKit

class AddFeedTableView: NSObject, UITableViewDelegate {
  
  // -MARK: - Properties -
  
  var selectedRowIndexPath: IndexPath? = nil
  var tableView: UITableView?
  var groups: [FeedGroupEntity]?
  
  init(tableView: UITableView?, groups: [FeedGroupEntity]?) {
    self.tableView = tableView
    self.groups = groups
  }
  
  enum Section {
    case main
  }
  
  lazy var dataSource: UITableViewDiffableDataSource<Section, String> = UITableViewDiffableDataSource(
    tableView: tableView!) { tableView, indexPath, itemIdentifier in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell", for: indexPath)
      cell.backgroundColor = UIColor.clear
      
      guard let groupName = self.groups?[indexPath.row].title
      else {
        return cell
      }
      
      cell.textLabel?.text = groupName
      
      if self.selectedRowIndexPath == indexPath {
        cell.backgroundColor = UIColor.lightGray
      }
      
      return cell
    }
  
  
  // -MARK: - Functions -
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRowIndexPath = indexPath
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    selectedRowIndexPath = nil
  }
  
  func configureInitialSnapshot(){
    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.main])
    
    guard groups != nil
    else {
      dataSource.apply(snapshot, animatingDifferences: false)
      return
    }
    
    for group in groups! {
      snapshot.appendItems([group.title] , toSection: .main)
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateSnapshot(withNewGroupName name: String){
    var snapshot = dataSource.snapshot()
    
    snapshot.appendItems([name], toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  
}
