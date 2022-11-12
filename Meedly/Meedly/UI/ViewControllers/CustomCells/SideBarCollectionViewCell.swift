//
//  CollectionViewCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 11.11.22.
//

import Foundation
import UIKit

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
    collectionImageView.layer.cornerRadius = 10
    collectionImageView.backgroundColor = .lightGray
    
    collectionImageView.layer.borderWidth = 2.5
    collectionImageView.layer.borderColor = UIColor(named: "mainColor")!.cgColor
  }
}
