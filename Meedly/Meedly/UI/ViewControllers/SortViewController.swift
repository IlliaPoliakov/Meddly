//
//  SortViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 8.11.22.
//

import Foundation
import UIKit

class SortViewController: UIViewController, UITableViewDelegate {
  
  enum Section {
    case staticSection
    case groupSection
  }
  
  // -MARK: - IBOutlets -
  
  @IBOutlet weak var tableView: UITableView!
  
  
  // -MARK: - Properties -
  
  var chosenPresentationType: String = "Show All"
  var groups: [String] = ["Show All", "New First", "Old First"]
  
  lazy var dataSource: UITableViewDiffableDataSource<Section, String> = UITableViewDiffableDataSource(
    tableView: tableView!) { tableView, indexPath, itemIdentifier in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "SortTableViewCell", for: indexPath)
      
      var groupName: String = "[no group name]"
      
      if indexPath.section == 0 {
        groupName = self.groups[indexPath.row]
      }
      else {
        groupName = self.groups[indexPath.row + 3]
        cell.imageView?.image = UIImage(systemName: "folder.circle")
      }
      
      cell.textLabel?.text = groupName
      
      return cell
    }
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = dataSource
    tableView.delegate = self
    
    configureInitialSnapshot()
  }
  
  // -MARK: - Functions -
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    chosenPresentationType = indexPath.section == 0 ? groups[indexPath.row] :
    groups[indexPath.row + 3]
    performSegue(withIdentifier: "unwindFromSort", sender: nil)
  }
  
  func configureInitialSnapshot(){
    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.staticSection, .groupSection])
    
    for i in (0..<groups.count) {
      if i < 3 {
        snapshot.appendItems([groups[i]], toSection: .staticSection)
      }
      else {
        snapshot.appendItems([groups[i]], toSection: .groupSection)
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
