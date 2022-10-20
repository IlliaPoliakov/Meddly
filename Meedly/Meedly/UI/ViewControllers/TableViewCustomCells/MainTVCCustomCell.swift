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
  @IBOutlet weak var feedImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func updateData(withFeed feed: Feed) {
    self.pubDateLabel.text = feed.pubDate
    self.titleLabel.text = feed.title
    if feed.image != nil {
      let cachesDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
      let path = cachesDirectory.appendingPathComponent("\(String(describing: feed.title)).jpg")
      guard let data = try? Data(contentsOf: path),
            let loaded = UIImage(data: data)
      else {
        return
      }
      self.feedImage.image = loaded
    }
  }
  
  
//  func saveImage(_ image: UIImage?) {
//      if let image = image {
//        if let data = image.jpegData(compressionQuality: 1.0) {
//          try? data.write(to: self)
//        }
//      } else {
//        try? FileManager.default.removeItem(at: self)
//      }
//    }
  
}
