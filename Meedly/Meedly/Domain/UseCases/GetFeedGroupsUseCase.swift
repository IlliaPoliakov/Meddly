//
//  GetGroupUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import Foundation
import UIKit

class GetFeedGroupsUseCase {
  
  private let repo: FeedGroupsRepository

  init(repo: FeedGroupsRepository) {
    self.repo = repo
  }
  
  func execute() -> [Group]? {
    return repo.getFeedGroups()
  }
}
