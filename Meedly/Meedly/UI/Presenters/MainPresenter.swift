//
//  MainPresenter.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import Foundation
import UIKit
import Combine

protocol MainPresenterProtocol: UICollectionViewDelegate {
  var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, FeedItem> { get }
  
  func intialize()
  func countGroups() -> [String]?
  func assignViewController(_ viewController: UIViewController)
  
  func sideBarButtonTupped()
  func addFeedButtonTupped()
  func updateButtonTupped()
  
  func presentationTypeChose(withType presentationType: PresentationType)
  func markAsReadForPeriodChose(withPeriod timePeriod: TimePeriod)
  func groupForPresentationChose(withTitle groupTitle: String)
  func sortTypeChose(withType sortType: SortType)
}


final class MainPresenter: NSObject, MainPresenterProtocol {

  // -MARK: - Dependensies -
  
  private weak var viewController: MainViewController?
  
  private let getItemsUseCase: GetItemsUseCase =
  AppDelegate.DIContainer.resolve(GetItemsUseCase.self)!
  private let adjustIdLikedStateUseCase: AdjustIsLikedStatetUseCase =
  AppDelegate.DIContainer.resolve(AdjustIsLikedStatetUseCase.self)!
  private let adjustIdReadStateUseCase: AdjustIsReadStateUseCase =
  AppDelegate.DIContainer.resolve(AdjustIsReadStateUseCase.self)!
  private let markAsReadUseCase: MarkAsReadUseCase =
  AppDelegate.DIContainer.resolve(MarkAsReadUseCase.self)!
  
  
  // -MARK: - Properties -
  
  private(set) var presentationType: PresentationType = .convinient
  
  private var subscribtions = Set<AnyCancellable>()
  
  private var feedItems: [FeedItem] = [FeedItem]()
  
  lazy var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, FeedItem> =
  UICollectionViewDiffableDataSource(collectionView: self.viewController!.collectionView) {
    collectionView, indexPath, itemIdentifier in
    guard !self.feedItems.isEmpty,
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell",
                                                        for: indexPath) as? MainViewCell
    else {
      return UICollectionViewCell()
    }
    
    let item = self.feedItems[indexPath.row]
    cell.bind(withFeedItem: self.feedItems[indexPath.row], withPresentationType: self.presentationType)
    
    cell.alpha = 1
    
    if item.isViewed == true {
      cell.alpha = 0.5
    }
    
    return cell
  }
  
  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: UIViewController){
    self.viewController = (viewController as? MainViewController)
  }
  
  func intialize() {
    self.updateButtonTupped()
  }
  
  func sideBarButtonTupped() {
     
  }
  
  func addFeedButtonTupped() {
    AppDelegate.router.presentAddFeedViewControole()
  }
  
  func updateButtonTupped() {
    refreshFeedItems()
  }
  
  func presentationTypeChose(withType presentationType: PresentationType) {
    guard self.presentationType != presentationType
    else {
      return
    }
    
    self.presentationType = presentationType
    
    viewController?.collectionView.reloadData()
  }
  
  func markAsReadForPeriodChose(withPeriod timePeriod: TimePeriod) {
    markAsReadUseCase.execute(forTimePeriod: timePeriod)
    for i in (0 ..< feedItems.count) {
      if feedItems[i].pubDate < Date(timeIntervalSinceNow: -timePeriod.rawValue) {
        feedItems[i].isViewed = true
      }
    }
    
    viewController?.collectionView.reloadData()
  }
  
  func groupForPresentationChose(withTitle groupTitle: String) {
    
  }
  
  func sortTypeChose(withType sortType: SortType) {
    
  }
  
  
  // -MARK: - SuppFuncs -
  
  func configureSnapshot(withItems feedItems: [FeedItem]?) {
    var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, FeedItem>()
    
    guard let feedItems
    else {
      return
    }
    
    snapshot.appendSections([.main])
    snapshot.appendItems(feedItems, toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func countGroups() -> [String]? {
    var groups: [String] = [DefaultGroup.defaultGroup.rawValue]

    guard !feedItems.isEmpty
    else {
      return groups
    }
    
    feedItems.forEach { item in
      if !groups.contains(where: { $0 == item.parentGroup }) {
        groups.append(item.parentGroup)
      }
    }
    
    return groups
  }
  
  func refreshFeedItems() {
    subscribtions.removeAll()
    
    getItemsUseCase.execute()
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .receive(on: DispatchQueue.main)
      .sink (receiveCompletion: { _ in
        self.configureSnapshot(withItems: self.feedItems)
      }) { result in
      switch result {
      case .success(let feedItems):
        let uniqueItems = self.checkForUniqueItems(feedItems)
        
        if let uniqueItems {
          self.feedItems.append(contentsOf: uniqueItems)
        }
        
        self.configureSnapshot(withItems: uniqueItems)
        
      case .failure(let error):
        AppDelegate.router.presentWarningAlert(
          withTitle: AllertMessage.ops.rawValue,
          withBody: "\(error.errorDescription ?? "Unknown")\(AllertMessage.errorOccured.rawValue)")
      }
    }
    .store(in: &subscribtions)
  }
  
  func checkForUniqueItems(_ feedItems: [FeedItem]) -> [FeedItem]?{
    guard !self.feedItems.isEmpty
    else {
      return feedItems
    }
    
    var resultItems = [FeedItem]()
    feedItems.forEach { item in
      if !self.feedItems.contains(where: { $0.title == item.title }){
        resultItems.append(item)
      }
    }
    
    if resultItems.isEmpty {
      return nil
    }
    return resultItems
  }
  
}

  // -MARK: - Extensions -

extension MainPresenter: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = feedItems[indexPath.row]
    AppDelegate.router.presentDescriptionViewControole(forFeedItem: item)
    
    if item.isViewed == false {
      collectionView.cellForItem(at: indexPath)?.alpha = 0.5
      feedItems[indexPath.row].isViewed = true
      adjustIdReadStateUseCase.execute(forFeedItem: item)
    }
  }
}
