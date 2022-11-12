//
//  MarkAsReadedOldUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 12.11.22.
//

import Foundation

class MarkAsReadedOldUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forTimePeriod timePeriod: String) {
    repo.markAsReadedOld(forTimePeriod: timePeriod)
  }
}
