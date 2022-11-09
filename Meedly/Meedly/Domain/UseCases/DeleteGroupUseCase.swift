//
//  DeleteGroupUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 9.11.22.
//

import Foundation

class DeleteGroupUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forGroup group: FeedGroup) {
    repo.deleteGroup(forGroup: group)
  }
}
