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
  
  func countGroups() -> [String]?
  func assignViewController(_ viewController: MainViewController)
  
  func sideBarButtonTupped()
  func addFeedButtonTupped()
  func updateButtonTupped()
  
  func presentationTypeChose(withType presentationType: PresentationType)
  func markAsReadForPeriodChose(withPeriod timePeriod: TimeInterval)
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
  
  
  // -MARK: - Properties -
  
  private(set) var presentationType: PresentationType = .convinient
  
  private var subscribtions = Set<AnyCancellable>()
  
  private var feedItems: [FeedItem]?
  
  lazy var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, FeedItem> =
  UICollectionViewDiffableDataSource(collectionView: self.viewController!.collectionView) {
    collectionView, indexPath, itemIdentifier in
    guard let item = self.feedItems?[indexPath.row],
          let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "MainVieCell", for: indexPath) as? MainViewCell
    else {
      return UICollectionViewCell()
    }
    
    cell.bind(withFeedItem: item, withPresentationType: self.presentationType)
    
    return cell
  }
  
  
  // -MARK: - Funcs -
  
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
  
  func markAsReadForPeriodChose(withPeriod timePeriod: TimeInterval) {
    
  }
  
  func groupForPresentationChose(withTitle groupTitle: String) {
    
  }
  
  func sortTypeChose(withType sortType: SortType) {
    
  }
  
  
  // -MARK: - SuppFuncs -
  
  func assignViewController(_ viewController: MainViewController){
    self.viewController = viewController
  }
  
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

    guard let feedItems
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
    
    getItemsUseCase.execute().sink { result in
      switch result {
      case .success(let feedItems):
        let uniqueItems = self.checkForUniqueItems(feedItems)
        
        if self.feedItems != nil,
           let uniqueItems {
          self.feedItems?.append(contentsOf: uniqueItems)
        }
        else {
          self.feedItems = uniqueItems
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
    guard let selfFeedItems = self.feedItems
    else {
      return feedItems
    }
    
    var resultItems = [FeedItem]()
    feedItems.forEach { item in
      if !selfFeedItems.contains(where: { $0.hashValue == item.hashValue }){
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
  
}
