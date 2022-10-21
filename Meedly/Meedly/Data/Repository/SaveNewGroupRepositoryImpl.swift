//
//  SaveNewGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class SaveNewGroupRepositoryImpl: SaveNewGroupRepository {
  
  private let localDataSource: LocalDataSource
  
  init(localDataSource: LocalDataSource) {
    self.localDataSource = localDataSource
  }
  
  func saveNewGroup(_ newGroupName: String) -> Group {
    return localDataSource.saveNewGroup(newGroupName)
  }
}
