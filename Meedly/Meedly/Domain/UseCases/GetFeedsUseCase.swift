//
//  GetFeedsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation
import Combine

class GetFeedsUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute() -> AnyPublisher<[FeedItem]?, Never> {
    return repo.getFeeds()
  }
}
