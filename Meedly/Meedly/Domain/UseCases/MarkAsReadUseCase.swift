//
//  MarkAsReadUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 25.11.22.
//

import Foundation

class MarkAsReadUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(forTimePeriod timePeriod: TimePeriod) {
    repo.markAsRead(forTimePeriod: timePeriod)
  }
}
