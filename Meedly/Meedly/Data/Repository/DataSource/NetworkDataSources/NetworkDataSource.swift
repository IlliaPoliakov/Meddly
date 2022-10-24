//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

class NetworkDataSource: RemoteDataSource {
  
  // ugly, but need for URLs
  let localDataSource: DataBaseDataSource = DataBaseDataSource()
  
  func loadData() -> [FeedGroupEntity]? {
    
    
    return nil // tmp
  }
  
}
