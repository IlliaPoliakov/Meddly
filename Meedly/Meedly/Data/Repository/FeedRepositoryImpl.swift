//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation


class FeedRepositoryImpl: FeedRepository {
  
  // -MARK: - Properties -
  
  private let localDataSource: LocalDataSource
  private let remoteDataSource: RemoteDataSource
  
  private var groups: [FeedGroupEntity]? = nil
  
  init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - Functional -
  
  func getCachedFeedGroups() -> [FeedGroupEntity]? {
    groups = localDataSource.loadData()
    return groups
  }
  
  func getLoadedFeedGroups() -> [FeedGroupEntity]? {
    if Connectivity.isConnectedToInternet() {
      
      
    }
    else {
      return groups
    }
    return groups
  }
  
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroupEntity {
    return localDataSource.saveNewGroup(withNewGroupName: newGroupName)
  }
  
  func saveNewFeed(_ newChanelUrl: URL, _ group: FeedGroupEntity) {
    localDataSource.saveNewFeed(withNewFeedUrl: newChanelUrl, withParentGroup: group)
  }
  
  func saveNewFeedItem(_ title: String,
                       _ feedDescription: String,
                       _ link: URL,
                       _ imageData: Data?,
                       _ pubDate: String,
                       _ group: FeedGroupEntity) {
    
    localDataSource.saveNewFeedItem(withTitle: title,
                                    withDescription: feedDescription,
                                    withLink: link,
                                    withImageData: imageData,
                                    withPubDate: pubDate,
                                    withhGroup: group)
  }
}
