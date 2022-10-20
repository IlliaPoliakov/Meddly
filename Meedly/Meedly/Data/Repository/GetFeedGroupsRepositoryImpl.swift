//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation


class GetFeedGroupsRepositoryImpl: GetFeedGroupsRepository {
  
  
  private let localDataSource: LocalDataSource
  private let remoteDataSource: RemoteDataSource
  
  
  init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  func getFeedGroups() -> [Group]? {
    
    return localDataSource.loadData()
  }
  
}
