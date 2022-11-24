//
//  AdjusIsLikedUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 18.11.22.
//

import Foundation

class AdjustIsLikedStatetUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forFeedItem feedItem: FeedItem) {
    repo.adjustIsLikedState(forFeedItem: feedItem)
  }
}
