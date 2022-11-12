//
//  MarkAsReadedUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 9.11.22.
//

import Foundation

class MarkAsReadedUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forFeedItem feedItem: FeedItem) {
    repo.markAsReaded(feedItem: feedItem)
  }
}
