//
//  GetGrouspUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 30.10.22.
//

import Foundation

class GetFeedGroupsUseCase {
  private let repo: FeedRepository

  init(repo: FeedRepository) {
    self.repo = repo
  }
  
  func execute(updateState state: UpdateState,
               _ completion: @escaping ([FeedGroup]?, String?) -> Void) {
    repo.getFeedGroups(updateState: state, completion)
  }
}
