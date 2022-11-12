//
//  MainTableView.swift
//  Meedly
//
//  Created by Illia Poliakov on 29.10.22.
//

import UIKit

class AddFeedTableView: NSObject, UITableViewDelegate {
  
  enum Section {
    case main
  }
  
  // -MARK: - Properties -
  
  var selectedRowIndexPath: IndexPath? = nil
  var tableView: UITableView?
  var groups: [FeedGroup]?
  var mainTableViewController: MainTableViewController = MainTableViewController()
  
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
  
  
  init(tableView: UITableView?, groups: [FeedGroup]?) {
    self.tableView = tableView
    self.groups = groups
  }
  
  
  // -MARK: - Dependencies -
  
  private let deleteGroupUseCase: DeleteGroupUseCase =
  AppDelegate.DIContainer.resolve(DeleteGroupUseCase.self)!
  
  
  // -MARK: - Functions -
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectedRowIndexPath == indexPath {
      tableView.cellForRow(at: indexPath)?.isSelected = false
      selectedRowIndexPath = nil
    }
    else {
      selectedRowIndexPath = indexPath
    }
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
  
  func tableView(_ tableView: UITableView,
                 contextMenuConfigurationForRowAt indexPath: IndexPath,
                 point: CGPoint) -> UIContextMenuConfiguration? {
    let groupImage = UIImage(systemName: "folder.circle")!
      .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    
    let group = self.groups![indexPath.row]
    
    guard group.title != "Default Group"
    else {
      return nil
    }
    
    return UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: nil) { _ in
        let deleteAction = UIAction(
          title: "Delete Group",
          image: groupImage) { _ in
            self.deleteGroupUseCase.execute(forGroup: group)
            self.groups!.remove(at: indexPath.row)
            
            self.mainTableViewController.updateGroups(updateState: .localUpdate) { newGroups in
              self.mainTableViewController.mainTableView.groups = newGroups
              self.mainTableViewController.mainTableView.updatePresentation()
            }
            self.configureInitialSnapshot()
          }
        
        return UIMenu(title: "", image: nil, children: [deleteAction])
      }
  }
  
}
