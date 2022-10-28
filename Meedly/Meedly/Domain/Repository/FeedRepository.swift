//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

protocol FeedRepository {
  func getCachedFeedGroups() -> [FeedGroupEntity]?
  func getLoadedFeedGroups(_ completion: @escaping ([FeedGroupEntity]?, String?) -> Void )
  func saveNewGroup(_ newGroupName: String) -> FeedGroupEntity
  func saveNewFeed(_ newFeedURL: URL, _ group: FeedGroupEntity)
}
