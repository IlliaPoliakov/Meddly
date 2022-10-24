//
//  GetFeedGroupsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

class SaveNewFeedUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(withNewFeedUrl url: URL, withParentGroup group: FeedGroupEntity) {
    return repo.saveNewFeed(url, group)
  }
}

