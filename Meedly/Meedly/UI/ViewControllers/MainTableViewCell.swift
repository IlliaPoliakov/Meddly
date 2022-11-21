//
//  MainTableViewCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.11.22.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class MainTableViewCell: UICollectionViewCell {
  
  var feedItem: FeedItem? {
    didSet {
      if let imageUrl = feedItem?.imageUrl {
        image.kf.setImage(with: imageUrl)
      }
      title.text = feedItem?.title
      pubDate.text = fee
    }
  }
  
  let image = UIImageView().then { (image) in
    image.layer.masksToBounds = true
    image.layer.cornerRadius(ConstantSize.imageCornerRadius)
  }
  
  let title = UILabel().then { label in
    label.numberOfLines = 0
  }
  
  let pubDate = UILabel().then { label in
    <#code#>
  }
  
}
