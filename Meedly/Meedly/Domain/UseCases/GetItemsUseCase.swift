//
//  GetItemsUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation
import Combine

class GetItemsUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute() -> AnyPublisher<Result<[FeedItem], MeedlyError>, Never> {
    return repo.getItems()
  }
}
