//
//  SideBarTableViewCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 10.11.22.
//

import UIKit
import PINRemoteImage

class SideBarTableViewCell: UITableViewCell {
  
  // -MARK: - IBOutlets -
  
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var groupNameLabel: UILabel!
  
  
  // -MARK: - Properties -
  
  var collectionViewOffset: CGFloat {
      get {
          return collectionView.contentOffset.x
      }

      set {
          collectionView.contentOffset.x = newValue
      }
  }
  
  
  // -MARK: - LifeCycle -

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  // -MARK: - Functions -

  func bind(withGroup group: FeedGroup) {
    groupNameLabel.text = group.title
    
  }
  
  func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
      collectionView.delegate = dataSourceDelegate
      collectionView.dataSource = dataSourceDelegate
      collectionView.tag = row
      collectionView.reloadData()
  }
}


class SideBarCollectionViewCell: UICollectionViewCell {
  
  // -MARK: - IBOutlets -
  
  @IBOutlet private weak var collectionImageView: UIImageView!
  @IBOutlet private weak var feedNameLabel: UILabel!
  
  
  // -MARK: - LifeCycle -

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  // -MARK: - Functions -
  
  func bind(withFeed feed: Feed) {
    feedNameLabel.text = feed.title
    
    if feed.imageUrl != nil {
      collectionImageView.pin_updateWithProgress = true
      collectionImageView.pin_setImage(from: feed.imageUrl!)
    }
    collectionImageView.layer.cornerRadius = collectionImageView.bounds.height / 2
    collectionImageView.backgroundColor = UIColor.white
  }
}
