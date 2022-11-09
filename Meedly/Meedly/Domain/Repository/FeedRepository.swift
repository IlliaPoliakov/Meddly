//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

protocol FeedRepository {
  func cleanData()
  
  func getFeedGroups(updateState state: UpdateState,
                     _ completion: @escaping ([FeedGroup]?, String?) -> Void )
  func saveNewGroup(_ newGroupName: String) -> FeedGroup
  func saveNewFeed(_ newFeedURL: URL, _ group: FeedGroup)
  func markAsReaded(feedItem item: FeedItem)
  func deleteFeed(forFeed feed: Feed)
  func deleteGroup(forGroup group: FeedGroup)
}
