//
//  ItemDescripitonViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation
import UIKit

class ItemDescriptinViewConrtoller: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UITextView!
  var titleString: String?
  var image: UIImage?
  var descriptionText: String?
  var link: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = titleString
    imageView.image = image
    descriptionLabel.text = descriptionText
    
    imageView.layer.cornerRadius = 10
  }
  
  @IBAction func visitWebSiteButtonTupped(sender: Any) {
    UIApplication.shared.open(link!)
  }
}
