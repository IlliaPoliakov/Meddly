//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

class FeedGroupsRepositoryImpl: FeedGroupsRepository {
  
  // -MARK: - Dependencies -
  
  private var localDataSource: FeedGroupsDataBaseDataSource
  private var remoteDataSource: FeedGroupsNetworkDataSource
  
  init(localDataSource: FeedGroupsDataBaseDataSource, remoteDataSource: FeedGroupsNetworkDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  func getFeedGroups() -> [Group] {
    
    return [Group()] // temporarry
  }
}
