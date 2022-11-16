//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

protocol FeedRepository {
  func getItems() -> Published<Any>//BLABLAA
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithName groupName: String)
  func deleteFeed(withName feedName: String)
  func deleteGroup(withName groupName: String)
  func markAsRead(_ feedItem: FeedItem?, forTimeInterval timeInterval: TimeIntervals?)
}
