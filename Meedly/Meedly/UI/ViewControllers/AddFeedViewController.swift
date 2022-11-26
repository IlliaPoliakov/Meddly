//
//  AddFeedViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 22.11.22.
//

import Foundation
import UIKit
import SnapKit

final class AddFeedViewController: UIViewController {
  
  init(_ presenter: AddFeedPresenterProtocol){
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
    
    presenter.loadFeeds()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    AppDelegate.router.navigationController.isToolbarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    AppDelegate.router.navigationController.isToolbarHidden = false
  }
  
  
  // -MARK: - Dependensies -
  
  private var presenter: AddFeedPresenterProtocol
  
  
  // -MARK: - Views -
  
  private var insertUrlLabel: UILabel!
  
  private var textField: UITextField!
  
  private var chooseGroupLabel: UILabel!
  
  private var addGroupButton: UIButton!
  
  private(set) var collectionView: UICollectionView!
  
  private var addFeedButton: UIButton!
  
  
  // -MARK: - Funcs -
  
  func setupViews() {
    self.view.backgroundColor = .systemBackground
    
    insertUrlLabel = UILabel().then { label in
      label.text = "Insert Your Url:"
      label.textColor = UIColor(named: "mainColor")
      label.font = .systemFont(ofSize: 32)
    }
    
    textField = UITextField().then { textField in
      textField.backgroundColor = UIColor(named: "mainColor")!.withAlphaComponent(0.2)
      textField.layer.cornerRadius = 10
      textField.layer.borderColor = UIColor(named: "mainColor")!.cgColor
      textField.layer.borderWidth = 1.5
      textField.font = .systemFont(ofSize: 25)
    } // magic nums, set left pudding
    
    chooseGroupLabel = UILabel().then { label in
      label.textColor = UIColor(named: "mainColor")
      label.text = "Choose Group or create New:"
      label.font = .systemFont(ofSize: 32)
      label.numberOfLines = 0
    }
    
    addGroupButton  = UIButton().then { button in
      button.setImage(UIImage(systemName: "folder.circle"), for: .normal)
      button.tintColor = UIColor(named: "mainColor")
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      button.addAction(UIAction(handler: {_ in self.presenter.addGroupButtonTupped()}),
                       for: .touchUpInside)
    }
    
    collectionView = {
      let layout = UICollectionViewCompositionalLayout {
        sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          repeatingSubitem: item,
          count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
      }
      
      let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
      
      collectionView.register(
        AddFeedCell.self,
        forCellWithReuseIdentifier: "AddFeedCell")
      
      collectionView.backgroundColor = UIColor(named: "mainColor")!.withAlphaComponent(0.2)
      collectionView.layer.cornerRadius = 15
      return collectionView
    }()
    collectionView.dataSource = presenter.dataSource
    collectionView.delegate = presenter
    
    addFeedButton = UIButton().then { button in
      button.setTitle("Add Feed", for: .normal)
      button.setTitleColor(UIColor(named: "mainColor")!, for: .normal)
      button.setTitleColor(UIColor(named: "mainColor")!.withAlphaComponent(0.3),
                           for: .highlighted)
      button.tintColor = UIColor(named: "mainColor")
      button.titleLabel?.font = .systemFont(ofSize: 32)
      button.backgroundColor = UIColor(named: "mainColor")!.withAlphaComponent(0.2)
      button.layer.cornerRadius = 10
      button.layer.borderWidth = 1.5
      button.layer.borderColor = UIColor(named: "mainColor")!.cgColor
      button.addAction(
        UIAction(handler: { _ in
          self.presenter.addFeedButtonTupped(withUrlString: self.textField.text)}),
        for: .touchUpInside)
    }
  }
  
  func layoutViews() {
    [insertUrlLabel, addGroupButton,
     collectionView, addFeedButton, textField, chooseGroupLabel].forEach {
      view in
      self.view.addSubview(view)
    }
    
    insertUrlLabel.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
      make.leading.trailing.equalToSuperview().inset(20)
    }
    
    textField.snp.makeConstraints { make in
      make.top.equalTo(insertUrlLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
      make.height.equalTo(insertUrlLabel.snp.height)
    }
    
    chooseGroupLabel.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(15)
      make.trailing.equalTo(addGroupButton.snp.leading).offset(-15)
    }
    
    addGroupButton.snp.makeConstraints { make in
      make.centerY.equalTo(chooseGroupLabel)
      make.trailing.equalToSuperview().offset(-25)
      make.height.equalTo(textField.snp.height)
      make.width.equalTo(textField.snp.height)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(chooseGroupLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
    }
    
    addFeedButton.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
      make.bottom.equalToSuperview().offset(-20)
    }
    
  }
}
