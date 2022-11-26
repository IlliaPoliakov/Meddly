//
//  DescriptionViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import Foundation
import UIKit
import Kingfisher

final class DescriptionViewController: UIViewController {
  
  init(_ presenter: DescriptionPresenterProtocol){
    self.presenter = presenter
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    layoutViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    AppDelegate.router.navigationController.isToolbarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    AppDelegate.router.navigationController.isToolbarHidden = false
  }
  

  // -MARK: - Dependencies -
  
  private var presenter: DescriptionPresenterProtocol
  
  
  // -MARK: - Properties -
  
  var feedItem: FeedItem? {
    didSet {
      if let imageUrl = feedItem?.imageUrl {
        setupImageView(withState: true)
        imageView.kf.setImage(with: imageUrl)
      }
      else {
        setupImageView(withState: false)
      }
      titleLabel.text = feedItem?.title
      descriptionLabel.text = feedItem?.itemDescription
      pubDateLabel.text = MeedlyDateFormatter.string(
        from: feedItem?.pubDate ?? Date(timeIntervalSinceNow: 0))
    }
  }
  
  
  // -MARK: - Views -
  
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  private var titleLabel: UILabel!
  
  private var imageView: UIImageView!
  
  private var pubDateLabel: UILabel!
  
  private var descriptionLabel: UILabel!
  
  private var goToWebSiteButton: UIButton!
  
  
  // -MARK: - Funcs -
  
  func setupViews() {
    self.view.backgroundColor = .systemBackground
    
    titleLabel = UILabel().then { label in
      label.numberOfLines = 0
      label.textAlignment = .center
      label.font = .systemFont(ofSize: 25)
    }
    
    imageView = UIImageView().then { image in
      image.layer.masksToBounds = true
      image.layer.cornerRadius = ConstantSize.imageCornerRadius.rawValue
      image.contentMode = .scaleAspectFill
    }
    
    pubDateLabel = UILabel().then { label in
      label.textAlignment = .right
      label.font = .systemFont(ofSize: 15)
      label.textColor = .lightGray
    }
    
    descriptionLabel = UILabel().then { label in
      label.textAlignment = .left
      label.font = .systemFont(ofSize: 20)
      label.textColor = .label
      label.numberOfLines = 0
    }
    
    goToWebSiteButton = UIButton().then { button in
      button.setTitle("Go To Web Site", for: .normal)
      button.setTitleColor(Colors.color(.mainColorClear)(), for: .normal)
      button.setTitleColor(Colors.color(.mainColorClear)().withAlphaComponent(0.3),
                           for: .highlighted)
      button.tintColor = Colors.color(.mainColorClear)()
      button.titleLabel?.font = .systemFont(ofSize: 32)
      button.backgroundColor = Colors.color(.mainColorBackground)()
      button.layer.cornerRadius = 10
      button.layer.borderWidth = 1.5
      button.layer.borderColor = Colors.color(.mainColorClear)().cgColor
      button.addAction(UIAction(handler: { _ in self.presenter.visiteWebSiteButtonTupped()}),
                       for: .touchUpInside)
    }
  }
  
  func layoutViews() {
    self.view.addSubview(scrollView)
    [titleLabel, descriptionLabel, imageView, pubDateLabel, goToWebSiteButton].forEach {
      view in
      scrollView.addSubview(view)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalTo(self.view).inset(15)
    }
    
    imageView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.leading.trailing.equalTo(self.view).inset(15)
      make.height.equalTo(self.view.frame.width * 0.6)
      make.width.equalTo(self.view.frame.width)
    }
    
    pubDateLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(15)
      make.leading.trailing.equalTo(self.view).inset(15)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(pubDateLabel.snp.bottom).offset(20)
      make.leading.trailing.equalTo(self.view).inset(15)
    }
    
    goToWebSiteButton.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
      make.leading.trailing.equalTo(self.view).inset(15)
      make.bottom.equalToSuperview().offset(-20)
    }
    
  }
  
  func setupImageView(withState state: Bool) {
    imageView.snp.makeConstraints { make in
      if state {
        make.height.equalTo(self.view.frame.width * 0.6)
      }
      else {
        make.height.equalTo(0)
      }
    }
  }
  
}
