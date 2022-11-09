//
//  MainTVCConvinientCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import UIKit
import PINRemoteImage

class MainTableViewControllerCustomCell: UITableViewCell {
  
  @IBOutlet weak var pubDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var itemImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func bind(withFeedItem item: FeedItem) {
    self.pubDateLabel.text = item.pubDate
    self.titleLabel.text = item.title
    self.itemImage.pin_updateWithProgress = true
    self.itemImage.pin_setImage(from: item.imageUrl!)
    self.itemImage.layer.cornerRadius = 10
    self.itemImage.backgroundColor = UIColor.white
  }

}
