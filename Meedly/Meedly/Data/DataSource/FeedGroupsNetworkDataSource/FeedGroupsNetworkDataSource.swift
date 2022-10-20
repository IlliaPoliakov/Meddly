//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

class FeedGroupsNetworkDataSource: RemoteDataSource {
  
  // ugly, but need for URLs
  let localDataSource: FeedGroupsDataBaseDataSource = FeedGroupsDataBaseDataSource()
  
  func loadData() -> [String: [Feed]]? {
    
    
    return nil // tmp
  }
  
}
