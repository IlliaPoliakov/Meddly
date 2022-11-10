//
//  SideBarViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 10.11.22.
//

import Foundation
import UIKit

enum Section {
  case main
}

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // -MARK: - IBOutlets -
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nickNameLavel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var emailLabel: UILabel!
  
  // -MARK: - Properties -
  
  var groups: [FeedGroup] = [FeedGroup]()
  var storedOffsets = [Int: CGFloat]()
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    stackView.layer.cornerRadius = 10
  }
  
  
  // -MARK: - TableView -
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarTableViewCell",
                                                   for: indexPath) as? SideBarTableViewCell
    else {
      return UITableViewCell()
    }
    
    cell.bind(withGroup: groups[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    guard let cell = cell as? SideBarTableViewCell
    else {
      return
    }
    cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self,
                                             forRow: indexPath.row)
    cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
  }
  
  private func tableView(tableView: UITableView,
                         didEndDisplayingCell cell: UITableViewCell,
                         forRowAtIndexPath indexPath: NSIndexPath) {
    guard let tableViewCell = cell as? SideBarTableViewCell
    else {
      return
    }
    storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
  }
  
}


// -MARK: - Extensions -

extension SideBarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  // -MARK: - CollectionView -
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "SideBarCollecitonViewCell",
      for: indexPath) as? SideBarCollectionViewCell
    else {
      return UICollectionViewCell()
    }

    cell.bind(withFeed: groups[collectionView.tag].feeds![indexPath.row])

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return groups[collectionView.tag].feeds?.count ?? 0
  }
}
