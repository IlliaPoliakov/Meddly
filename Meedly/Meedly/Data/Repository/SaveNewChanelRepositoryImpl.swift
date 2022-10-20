//
//  SaveNewGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class SaveNewChanelRepositoryImpl: SaveNewChanelRepository {
  
  private let localDataSource: LocalDataSource
  
  init(localDataSource: LocalDataSource) {
    self.localDataSource = localDataSource
  }
  
  func saveNewChanel(_ newChanelUrl: String) {
    localDataSource.saveNewChanel(newChanelUrl)
  }
}
