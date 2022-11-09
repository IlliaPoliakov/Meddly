//
//  DeleteFeedUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 9.11.22.
//

import Foundation

class DeleteFeedUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forFeed feed: Feed) {
    repo.deleteFeed(forFeed: feed)
  }
}
