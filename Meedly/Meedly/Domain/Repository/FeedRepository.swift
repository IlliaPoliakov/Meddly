//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

protocol FeedRepository {
  func getFeedGroups() -> [FeedGroup]?
  func saveNewGroup(_ newGroupName: String) -> FeedGroup
  func saveNewFeed(_ newChanelURl: URL, _ group: FeedGroup)
}
