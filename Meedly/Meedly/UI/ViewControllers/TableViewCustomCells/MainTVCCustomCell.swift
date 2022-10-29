//
//  MainTVCConvinientCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import UIKit

class MainTableViewControllerCustomCell: UITableViewCell {
  
  @IBOutlet weak var pubDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var itemImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func bind(withFeedItem item: FeedItemEntity) {
    self.pubDateLabel.text = item.pubDate
    self.titleLabel.text = item.title
    
    guard item.imageData != nil
    else {
      return
    }
    
    self.itemImage.image = UIImage(data: item.imageData!)
    self.itemImage.layer.cornerRadius = 10
    self.itemImage.backgroundColor = UIColor.white
  }

}
