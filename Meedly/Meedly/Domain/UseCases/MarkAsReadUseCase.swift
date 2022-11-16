//
//  MarkAsReadedUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 9.11.22.
//

import Foundation

class MarkAsReadUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forFeedItem feedItem: FeedItem?, forTimeInterval timeIntetrval: TimeIntervals?) {
    repo.markAsRead(feedItem, forTimeInterval: timeIntetrval)
  }
}
