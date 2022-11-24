//
//  MainViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.11.22.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
  
  init(_ presenter: MainPresenterProtocol){
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
    
    collectionView.dataSource = presenter.dataSource
    collectionView.delegate = presenter
    
    presenter.updateButtonTupped() //????
    
    self.title = SortType.all.rawValue
  }
  
  
  // -MARK: - Dependencies -
  
  private var presenter: MainPresenterProtocol
  
  
  // -MARK: - Views -
  
  private(set) var collectionView: UICollectionView!
  
  private var sortButton: UIBarButtonItem!
  
  private var sideBarButton: UIBarButtonItem!
  
  private var addFeedButton: UIBarButtonItem!
  
  private var updateButton: UIBarButtonItem!
  
  private var presentationTypeButton: UIBarButtonItem!
  
  private var markAsReadButton: UIBarButtonItem!
  
  
  // -MARK: - Funcs -
  
  private func setupViews() {
    collectionView = {
      let layout = UICollectionViewCompositionalLayout {
        sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(0))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          repeatingSubitem: item,
          count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return section
      }
      
      let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
      
      collectionView.register(
        MainViewCell.self,
        forCellWithReuseIdentifier: "MainCollectionViewCell")
      
      return collectionView
    }()
    
    sortButton = {
      let button: UIButton = UIButton(type: .custom)
      button.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal"), for: .normal)
      button.tintColor = Colors.color(.mainColorClear)()
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill

      button.menu = UIMenu(title: "Sort presentation:", children: [
        self.makeGroupsMenu(),
        self.makeOldFirstAction(),
        self.makeNewFirstAction(),
        self.makeUnreadOnlyAction(),
        self.makeAllAction()
      ])
      
      button.showsMenuAsPrimaryAction = true
      button.changesSelectionAsPrimaryAction = true
      
      return UIBarButtonItem(customView: button)
    }()
    
    sideBarButton = {
      let button: UIButton = UIButton(type: .custom)
      button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
      button.tintColor = Colors.color(.mainColorClear)()
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      
      button.addAction(UIAction(handler: { _ in self.presenter.sideBarButtonTupped() }),
                       for: .touchUpInside)
      
      return UIBarButtonItem(customView: button)
    }()
    
    addFeedButton  = {
      let button: UIButton = UIButton(type: .custom)
      button.setImage(UIImage(systemName: "plus.app"), for: .normal)
      button.tintColor = Colors.color(.mainColorClear)()
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      
      button.addAction(UIAction(handler: { _ in self.presenter.addFeedButtonTupped() }),
                       for: .touchUpInside)
      
      return UIBarButtonItem(customView: button)
    }()
    
    presentationTypeButton  = {
      let button: UIButton = UIButton(type: .custom)
      button.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
      button.tintColor = Colors.color(.mainColorClear)()
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      button.menu = UIMenu(
        title: "Set Presentation Type:",
        children: [
          UIAction(title: PresentationType.convinient.rawValue,
                   state: .off) { _ in
                     self.presenter.presentationTypeChose(withType: .convinient)
                     button.setTitle(nil, for: .normal)
                   },
          UIAction(title: PresentationType.textOnly.rawValue,
                   state: .off) { _ in
                     self.presenter.presentationTypeChose(withType: .textOnly)
                     button.setTitle(nil, for: .normal)
                   }
        ])
      
      button.showsMenuAsPrimaryAction = true
      button.changesSelectionAsPrimaryAction = true
      
      button.setTitle(nil, for: .normal) //costil
      
      return UIBarButtonItem(customView: button)
    }()
    
    markAsReadButton  = {
      let button: UIButton = UIButton(type: .custom)
      button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
      button.tintColor = Colors.color(.mainColorClear)()
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      button.menu = UIMenu(
        title: "Mark As Read News, Older than:",
        children: [
          UIAction(title: TimePeriodText.oneHour.rawValue,
                   state: .off) { _ in self.presenter.markAsReadForPeriodChose(
                    withPeriod: TimePeriod.oneHour.rawValue) },
          UIAction(title: TimePeriodText.oneDay.rawValue,
                   state: .off) { _ in self.presenter.markAsReadForPeriodChose(
                    withPeriod: TimePeriod.oneDay.rawValue) },
          UIAction(title: TimePeriodText.twoDays.rawValue,
                   state: .off) { _ in self.presenter.markAsReadForPeriodChose(
                    withPeriod: TimePeriod.twoDays.rawValue) },
          UIAction(title: TimePeriodText.oneWeak.rawValue,
                   state: .off) { _ in self.presenter.markAsReadForPeriodChose(
                    withPeriod: TimePeriod.oneWeak.rawValue) }
        ])
      
      button.showsMenuAsPrimaryAction = true
      
      return UIBarButtonItem(customView: button)
    }()
    
    updateButton  = {
      let button: UIButton = UIButton(type: .custom)
      button.setImage(UIImage(systemName: "clock.arrow.circlepath"), for: .normal)
      button.tintColor = Colors.color(.mainColorClear)()
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      button.addAction(UIAction(handler: { _ in self.presenter.updateButtonTupped() }),
                       for: .touchUpInside)
      
      return UIBarButtonItem(customView: button)
    }()
    
    setupBarsItems()
  }
  
  private func setupBarsItems() {
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    self.toolbarItems = [space, sideBarButton, space, sortButton, space, addFeedButton, space]
    
    self.navigationItem.leftBarButtonItem = updateButton
    self.navigationItem.rightBarButtonItems = [markAsReadButton, presentationTypeButton]
  }
  
  private func layoutViews() {
    self.view.addSubview(collectionView)
    
    collectionView.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
    
    sortButton.customView?.snp.makeConstraints { make in
      make.width.equalTo(25)
      make.height.equalTo(20)
    }
    
    sideBarButton.customView?.snp.makeConstraints { make in
      make.height.equalTo(18)
      make.width.equalTo(25)
    }
    
    addFeedButton.customView?.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
    
    updateButton.customView?.snp.makeConstraints { make in
      make.width.height.equalTo(25)
    }
    
    presentationTypeButton.customView?.snp.makeConstraints { make in
      make.width.height.equalTo(25)
    }
    
    markAsReadButton.customView?.snp.makeConstraints { make in
      make.width.height.equalTo(25)
    }
  }
  
  private func makeAllAction() -> UIAction {
    let allImage = UIImage(systemName: "books.vertical")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: SortType.all.rawValue,
      image: allImage,
      identifier: nil,
      state: .on) { _ in
        self.presenter.sortTypeChose(withType: SortType.all)
        self.title = SortType.all.rawValue
      }
  }
  
  private func makeUnreadOnlyAction() -> UIAction {
    let unreadImage = UIImage(systemName: "bookmark.slash")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: SortType.unreadOnly.rawValue,
      image: unreadImage,
      identifier: nil) { _ in
        self.presenter.sortTypeChose(withType: SortType.unreadOnly)
        self.title = SortType.unreadOnly.rawValue
      }
  }
  
  private func makeNewFirstAction() -> UIAction {
    let newFirstImage = UIImage(systemName: "dock.arrow.down.rectangle")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: SortType.newFirst.rawValue,
      image: newFirstImage,
      identifier: nil) { _ in
        self.presenter.sortTypeChose(withType: SortType.newFirst)
        self.title = SortType.newFirst.rawValue
      }
  }
  
  private func makeOldFirstAction() -> UIAction {
    let oldFirstImage = UIImage(systemName: "dock.arrow.up.rectangle")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: SortType.oldFirst.rawValue,
      image: oldFirstImage,
      identifier: nil) { _ in
        self.presenter.sortTypeChose(withType: SortType.oldFirst)
        self.title = SortType.oldFirst.rawValue
      }
  }
  
  private func makeGroupsMenu() -> UIMenu {
    var groupsActions = [UIMenuElement]()
    
    let circleGroupImage = UIImage(systemName: "folder.circle")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    if let groups = presenter.countGroups() {
      groupsActions = groups.enumerated().map { index, group in
        return UIAction(
          title: group,
          image: circleGroupImage,
          attributes: .keepsMenuPresented) { _ in
            self.presenter.groupForPresentationChose(withTitle: group)
          }
      }
    }
    
    let allImage = UIImage(systemName: "books.vertical")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    groupsActions.append(
      UIAction(
        title: "All",
        image: allImage,
        attributes: .keepsMenuPresented) { _ in
          self.presenter.groupForPresentationChose(withTitle: "All")
        }
    )
    
    
    let groupsImage = UIImage(systemName: "folder")!
      .withTintColor(Colors.color(.mainColorClear)(), renderingMode: .alwaysOriginal)
    
    
    return UIMenu(
      title: "Group",
      image: groupsImage,
      children: groupsActions)
  }
}


// -MARK: - Extensions -
