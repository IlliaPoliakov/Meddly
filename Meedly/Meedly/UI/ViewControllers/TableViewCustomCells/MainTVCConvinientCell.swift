//
//  MainTVCConvinientCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import UIKit

class MainTVCConvinientCell: UITableViewCell {

  @IBOutlet weak var pubDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var feedImage: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
