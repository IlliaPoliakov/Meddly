//
//  SideBarViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import Foundation
import UIKit

final class SideBarViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    layoutViews()
  }
  
  
  // -MARK: - Views -
  
  private var avatarImageView: UIImageView!
  
  private var nickNameLabel: UILabel!
  
  private var collectionView: UICollectionView!
  
  
  // -MARK: - Funcs -
  
  func setupViews() {
    avatarImageView = UIImageView().then { image in
      image.layer.cornerRadius = 30
      image.contentMode = .scaleAspectFill
      image.image = UIImage(named: "defaultAvatarImage")
      image.alpha = 0.2
      image.layer.borderWidth = 1.5
      image.layer.borderColor = Colors.color(.mainColorClear)().cgColor
      image.layer.masksToBounds = true
    } // set actual info
    
    nickNameLabel = UILabel().then { label in
      label.text = "Insert Your Url:"
      label.textColor = Colors.color(.mainColorClear)()
      label.font = .systemFont(ofSize: 25)
    } //actual info
    
    collectionView = {
      let layout = UICollectionViewCompositionalLayout {
        sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .estimated(0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return section
      }
      
      let collectionView = UICollectionView(frame: self.view.frame,
                                            collectionViewLayout: layout)
      
      collectionView.register(
        MainViewCell.self,
        forCellWithReuseIdentifier: "MainCollectionViewCell")
      
      collectionView.backgroundColor = Colors.color(.mainColorBackground)()
      collectionView.layer.cornerRadius = 15
      return collectionView
    }()
  }
  
  func layoutViews() {
    [nickNameLabel, avatarImageView, collectionView].forEach {
      view in
      self.view.addSubview(view)
    }
    
    avatarImageView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
      make.height.width.equalTo(self.view.frame.width / 3)
      make.leading.equalToSuperview().offset(20)
    }
    
    nickNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
      make.trailing.equalToSuperview().offset(-20)
      make.centerY.equalTo(avatarImageView)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(avatarImageView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
      make.bottom.equalToSuperview().offset(-20)
    }
    
  }
}
