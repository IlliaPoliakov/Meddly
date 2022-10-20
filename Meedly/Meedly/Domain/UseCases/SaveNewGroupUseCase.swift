//
//  GetFeedGroupsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class SaveNewGroupUseCase {
  private let repo: SaveNewGroupRepository

  init(repo: SaveNewGroupRepository) {
    self.repo = repo
  }
  
  func execute(_ newGroupName: String) -> Group {
    return repo.saveNewGroup(newGroupName)
  }
}
