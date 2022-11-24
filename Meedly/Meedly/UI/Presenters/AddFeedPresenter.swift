//
//  AddFeedPresenter.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import Foundation
import UIKit
import Combine

protocol AddFeedPresenterProtocol: UICollectionViewDelegate {
  var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, String> { get }
  
  func assignViewController(_ viewController: AddFeedViewController)
  
  func addGroupButtonTupped()
  func addFeedButtonTupped(withUrlString urlString: String?)
  
  func loadFeeds()
}


final class AddFeedPresenter: NSObject, AddFeedPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: AddFeedViewController?
  
  private let saveNewFeedUseCase: SaveNewFeedUseCase =
  AppDelegate.DIContainer.resolve(SaveNewFeedUseCase.self)!
  private let getFeedsUseCase: GetFeedsUseCase =
  AppDelegate.DIContainer.resolve(GetFeedsUseCase.self)!
  
  
  // -MARK: - Properties -
  
  private var feeds: [Feed]?
  private lazy var groups = countGroups()
  private var savedIndexPath: IndexPath? = nil
  
  lazy var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, String> =
  UICollectionViewDiffableDataSource(collectionView: viewController!.collectionView) {
    collectionView, indexPath, itemIdentifier in
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "AddFeedCell", for: indexPath) as? AddFeedCell
    else {
      return UICollectionViewCell()
    }
    
    cell.groupTitle = self.groups[indexPath.row]
    
    return cell
  }
  
  
  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: AddFeedViewController) {
    self.viewController = viewController
  }
  
  func configureSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, String>()
    snapshot.appendSections([.main])
    snapshot.appendItems(groups, toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func loadFeeds() {
    var subscription: AnyCancellable? = nil
    
    subscription = getFeedsUseCase.execute()
      .sink(receiveCompletion: { _ in
        subscription?.cancel()
        
        self.configureSnapshot()
      }) { feeds in
        self.feeds = feeds
      }
  }
  
  func countGroups() -> [String] {
    var groups: [String] = [DefaultGroup.defaultGroup.rawValue]

    guard let feeds
    else {
      return groups
    }
    
    feeds.forEach { feed in
      if !groups.contains(where: { $0 == feed.parentGroup }) {
        groups.append(feed.parentGroup)
      }
    }
    
    return groups
  }
  
  
  func addGroupButtonTupped() {
    AppDelegate.router.presentAddGroupAlert { newGroupTitle in
      guard let newGroupTitle
      else {
        return
      }
      
      if !self.groups.contains(where: { $0 == newGroupTitle}){
        self.groups.append(newGroupTitle)
        
        var snapshot = self.dataSource.snapshot()
        snapshot.appendItems([newGroupTitle], toSection: .main)
        self.dataSource.apply(snapshot)
      }
      else {
        AppDelegate.router.presentWarningAlert(
          withTitle: AllertMessage.groupExist.rawValue, withBody: "")
      }
    }
  }
  
  func addFeedButtonTupped(withUrlString urlString: String?) {
    guard let savedIndexPath
    else {
      AppDelegate.router.presentWarningAlert(
        withTitle: AllertMessage.chooseGroup.rawValue, withBody: "")
      return
    }
    let groupTitle = groups[savedIndexPath.row]
    
    guard let urlString,
          let url = URL(string: urlString)
    else {
      AppDelegate.router.presentWarningAlert(
        withTitle: AllertMessage.checkUrl.rawValue, withBody: "")
      return
    }
    
    if let feeds {
      guard !feeds.contains(where: { $0.link == url})
      else {
        AppDelegate.router.presentWarningAlert(
          withTitle: AllertMessage.feedExist.rawValue, withBody: "")
        return
      }
    }
    
    saveNewFeedUseCase.execute(withUrl: url, inGroupWithTitle: groupTitle)
    
//    AppDelegate.router.closeViewController(self.addFeedViewController!)
  }
  
}

extension AddFeedPresenter: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let savedIndexPath {
      collectionView.deselectItem(at: savedIndexPath, animated: true)
    }
    
    collectionView.selectItem(at: indexPath,
                              animated: true,
                              scrollPosition: .centeredVertically)
    self.savedIndexPath = indexPath
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    savedIndexPath = nil
  }
}
