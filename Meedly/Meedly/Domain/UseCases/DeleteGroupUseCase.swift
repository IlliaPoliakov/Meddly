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
  
  func execute(withGroupName groupName: String) {
    repo.deleteGroup(withName: groupName)
  }
}
