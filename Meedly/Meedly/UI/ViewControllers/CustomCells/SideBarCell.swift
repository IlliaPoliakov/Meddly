//
//  SideBarCell.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.11.22.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class SideBarCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViewes()
    layoutViewes()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // -MARK: - Properties -
  
  var feedItem: FeedItem? {
    didSet {
      if let imageUrl = feedItem?.imageUrl {
        imageView.kf.setImage(with: imageUrl)
      }
      titleLabel.text = feedItem?.title
    }
  }
  
  
  // -MARK: - Views -
  
  private var imageView: UIImageView!
  
  private var titleLabel: UILabel!
  
  
  // -MARK: - Funcs -
  
  func bind(withFeedItem feedItem: FeedItem, withPresentationType presentationType: PresentationType){
    self.feedItem = feedItem
    
    if presentationType == .convinient,
       feedItem.imageUrl != nil {
      layoutImageView(withState: true)
    }
    else {
      layoutImageView(withState: false)
    }
  }
  
  private func setupViewes() {
    imageView = UIImageView().then { image in
      image.image = UIImage(systemName: "folder.circle")
      image.tintColor = Colors.color(.mainColorClear)()
      image.layer.masksToBounds = true
      image.contentMode = .scaleAspectFill
    }
    
    titleLabel = UILabel().then { label in
      label.numberOfLines = 0
      label.textAlignment = .left
      label.font = .systemFont(ofSize: 20)
    }
  }
  
  private func layoutViewes() {
    [imageView, titleLabel].forEach { view in
      self.addSubview(view)
    }
    
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(15)
      make.height.width.equalTo(self.frame.width * 0.1)
      make.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalTo(imageView)
      make.leading.equalTo(imageView.snp.trailing).offset(15)
      make.trailing.equalToSuperview().inset(15)
    }
  }
  
  func layoutImageView(withState state: Bool) {
    imageView.snp.makeConstraints { make in
      if state {
        make.height.equalTo(self.frame.width * 0.6)
      }
      else {
        make.height.equalTo(0)
      }
    }
  }
  
}
