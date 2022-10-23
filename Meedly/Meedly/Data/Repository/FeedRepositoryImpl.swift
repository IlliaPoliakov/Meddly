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
  
  
  init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - Functional -
  
  func getFeedGroups() -> [FeedGroup]? {
    var groups: [FeedGroup]? = localDataSource.loadData()
    if Reachability.isConnectedToNetwork() {
      
      ///
    }
    else {
      return groups
    }
    return groups
  }
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroup {
    return localDataSource.saveNewGroup(withNewGroupName: newGroupName)
  }
  
  func saveNewFeed(_ newChanelUrl: URL, _ group: FeedGroup) {
    localDataSource.saveNewFeed(withNewFeedUrl: newChanelUrl, withParentGroup: group)
  }
}
