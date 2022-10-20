//
//  GetFeedGroupsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class GetFeedGroupsUseCase {
  private let repo: GetFeedGroupsRepository

  init(repo: GetFeedGroupsRepository) {
    self.repo = repo
  }
  
  func execute() -> [Group]? {
    return repo.getFeedGroups()
  }
}
