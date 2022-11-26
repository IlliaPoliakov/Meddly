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
  
  func assignViewController(_ viewController: UIViewController)
  
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
  private let delete: DeleteFeedUseCase =///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  AppDelegate.DIContainer.resolve(DeleteFeedUseCase.self)!
  
  
  // -MARK: - Properties -
  
  private var feeds = [Feed]()
  private var groups = [String]()
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
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? AddFeedViewController)
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
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in
        subscription?.cancel()
        
        self.groups = self.countGroups()
        
        self.configureSnapshot()
      }) { feeds in
        self.feeds = feeds
      }
  }
  
  func countGroups() -> [String] {
    self.groups = [DefaultGroup.defaultGroup.rawValue]

    guard !feeds.isEmpty
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
    
    if !feeds.isEmpty {
      guard !feeds.contains(where: { $0.link == url})
      else {
        AppDelegate.router.presentWarningAlert(
          withTitle: AllertMessage.feedExist.rawValue, withBody: "")
        return
      }
    }
    
    saveNewFeedUseCase.execute(withUrl: url, inGroupWithTitle: groupTitle)
    
    AppDelegate.router.closeAddFeedViewController()
  }
  
}

extension AddFeedPresenter: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard savedIndexPath != indexPath
    else {
      collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
      savedIndexPath = nil
      return
    }
    
    if let savedIndexPath {
      collectionView.cellForItem(at: savedIndexPath)?.backgroundColor = .clear
      self.savedIndexPath = nil
    }
    
    collectionView.cellForItem(at: indexPath)?.backgroundColor =
      .lightGray.withAlphaComponent(0.5)
    
    self.savedIndexPath = indexPath
  }
}
