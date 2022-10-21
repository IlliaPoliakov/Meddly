//
//  GetFeedGroupsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class SaveNewChanelUseCase {
  private let repo: SaveNewChanelRepository

  init(repo: SaveNewChanelRepository) {
    self.repo = repo
  }
  
  func execute(_ newChanelUrl: URL, _ group: Group) {
    return repo.saveNewChanel(newChanelUrl, group)
  }
}

