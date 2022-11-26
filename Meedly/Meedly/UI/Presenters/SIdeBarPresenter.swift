//
//  SIdeBarPresenter.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import UIKit

protocol SideBarPresenterProtocol: UICollectionViewDelegate {
  var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, FeedItem> { get }
  
  func assignViewController(_ viewController: UIViewController)
  
}


final class SideBarPresenter: NSObject, SideBarPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: MainViewController?
  
  private let getFeedsUseCase: GetFeedsUseCase =
  AppDelegate.DIContainer.resolve(GetFeedsUseCase.self)!
  private let deleteGroupUseCase: DeleteGroupUseCase =
  AppDelegate.DIContainer.resolve(DeleteGroupUseCase.self)!
  private let deleteFeedUseCase: DeleteFeedUseCase =
  AppDelegate.DIContainer.resolve(DeleteFeedUseCase.self)!
  
  
  // -MARK: - Properties -
  
  private var feeds: [Feed] = [Feed]()
  
  lazy var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, FeedItem> =
  UICollectionViewDiffableDataSource(collectionView: self.viewController!.collectionView) {
    collectionView, indexPath, itemIdentifier in
    guard !self.feeds.isEmpty,
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell",
                                                        for: indexPath) as? MainViewCell
    else {
      return UICollectionViewCell()
    }
    
    let feed = self.feeds[indexPath.row]
    
//    cell.bind(withFeedItem: , withPresentationType: self.presentationType)
    
    return cell
  }
  
  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: UIViewController){
    self.viewController = (viewController as? MainViewController)
  }
  
}
