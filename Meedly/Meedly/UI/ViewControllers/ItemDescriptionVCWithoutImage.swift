//
//  ItemDescripitonViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation
import UIKit
import PINRemoteImage

class ItemDescriptinViewConrtollerWithoutImage: UIViewController {
  
  // -MARK: - IBOutlets -
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UITextView!
  
  // -MARK: - Properties -
  
  var item: FeedItem?
  
  
  // -MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = item!.title
    descriptionLabel.text = item!.feedItemDescription
  }
  
  
  // -MARK: - IBActions and Functions
  
  @IBAction func visitWebSiteButtonTupped(_ sender: Any) {
    UIApplication.shared.open(item!.link)
  }
}
