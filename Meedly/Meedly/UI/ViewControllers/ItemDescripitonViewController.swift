//
//  ItemDescripitonViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation
import UIKit
import PINRemoteImage

class ItemDescriptinViewConrtoller: UIViewController {
  
  // -MARK: - IBOutlets -
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UITextView!
  
  
  // -MARK: - Properties -
  
  var item: FeedItem?
  
  
  // -MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = item!.title
    if item?.imageUrl != nil {
      imageView.pin_setImage(from: item!.imageUrl!)
    }
    descriptionLabel.text = item!.feedItemDescription
    
    imageView.layer.cornerRadius = 10
    imageView.backgroundColor = UIColor.white
  }
  
  
  // -MARK: - IBActions and Functions
  
  @IBAction func visitWebSiteButtonTupped(_ sender: Any) {
    UIApplication.shared.open(item!.link)
  }
}
