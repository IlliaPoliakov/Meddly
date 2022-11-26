//
//  MarkAsReadedUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 9.11.22.
//

import Foundation

class AdjustIsReadStateUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forFeedItem feedItem: FeedItem) {
    repo.adjustIsReadState(forFeedItem: feedItem)
  }
}
