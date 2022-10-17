//
//  GetGroupUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import Foundation
import UIKit

class GetFeedsUseCase {
  
  private let repo: FeedsRepository

  init(repo: FeedsRepository) {
    self.repo = repo
  }
  
  func execute() -> [Feed] {
    return repo.getFeeds()
  }
}
