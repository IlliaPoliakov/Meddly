//
//  MainTVCConvinientCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import UIKit

class MainVCCustomCellWithoutText: UITableViewCell {
  
  @IBOutlet weak var pubDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func bind(withFeedItem item: FeedItemEntity) {
    self.pubDateLabel.text = item.pubDate
    self.titleLabel.text = item.title
  }
}
