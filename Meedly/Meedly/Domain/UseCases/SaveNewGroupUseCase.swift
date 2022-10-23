//
//  GetFeedGroupsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class SaveNewGroupUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(withNewGroupName group: String) -> FeedGroup {
    return repo.saveNewGroup(group)
  }
}
