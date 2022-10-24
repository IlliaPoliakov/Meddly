//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

protocol FeedRepository {
  func getFeedGroups() -> [FeedGroupEntity]?
  func saveNewGroup(_ newGroupName: String) -> FeedGroupEntity
  func saveNewFeed(_ newFeedURL: URL, _ group: FeedGroupEntity)
  func saveNewFeedItem(_ title: String,
                       _ feedDescription: String,
                       _ link: URL,
                       _ imageData: Data?,
                       _ pubDate: String,
                       _ group: FeedGroupEntity)
}
