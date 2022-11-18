//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Combine

protocol FeedRepository {
  func getItems() -> AnyPublisher<[FeedItem]?, MeedlyError>
  func getFeeds() -> AnyPublisher<[Feed]?, MeedlyError>
  
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithTitle groupTitle: String)
  
  func deleteFeed(withTitle feedTitle: String)
  func deleteGroup(withTitle groupTitle: String)
  
  func adjustIsReadState(forFeedItem feedItem: FeedItem?, forTimePeriod timePeriod: TimePeriod?)
  func adjustIsLikedState(forFeedItem feedItem: FeedItem)
}
