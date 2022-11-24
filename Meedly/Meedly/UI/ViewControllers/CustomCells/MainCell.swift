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

final class MainViewCell: UICollectionViewCell {
  
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
      pubDateLabel.text = meedlyDateFormatter.string(from: feedItem?.pubDate ?? Date(timeIntervalSinceNow: 0))
    }
  }
  
  
  // -MARK: - Views -
  
  private var imageView: UIImageView!
  
  private var titleLabel: UILabel!
  
  private var pubDateLabel: UILabel!
  
  
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
    imageView = UIImageView().then { image in // add shades
      image.layer.masksToBounds = true
      image.layer.cornerRadius = ConstantSize.imageCornerRadius.rawValue
      image.contentMode = .scaleAspectFill
    }
    
    titleLabel = UILabel().then { label in
      label.numberOfLines = 0
      label.textAlignment = .left
      label.font = .systemFont(ofSize: 20)
    }
    
    pubDateLabel = UILabel().then { label in
      label.textAlignment = .right
      label.font = .systemFont(ofSize: 15)
      label.textColor = .lightGray
    }
  }
  
  private func layoutViewes() {
    [imageView, titleLabel, pubDateLabel].forEach { view in
      self.addSubview(view)
    }
    
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.leading.trailing.equalToSuperview().inset(15)
      make.height.equalTo(self.frame.width * 0.6)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
    }
    
    pubDateLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.leading.trailing.equalToSuperview().inset(15)
      make.bottom.equalToSuperview()
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
