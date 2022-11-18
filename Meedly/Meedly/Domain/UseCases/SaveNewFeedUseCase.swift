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
  
  func execute(withUrl feedUrl: URL, inGroupWithTitle groupTitle: String) {
    return repo.saveNewFeed(withUrl: feedUrl, inGroupWithTitle: groupTitle)
  }
}
