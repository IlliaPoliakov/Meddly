//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Combine

protocol FeedRepository {
  func getItems() -> AnyPublisher<Result<[FeedItem], MeedlyError>, Never>
  func getFeeds() -> AnyPublisher<[Feed], Never>
  
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithTitle groupTitle: String)
  
  func deleteFeed(withTitle feedTitle: String)
  func deleteGroup(withTitle groupTitle: String)
  
  func markAsRead(forTimePeriod timePeriod: TimePeriod)
  func adjustIsReadState(forFeedItem feedItem: FeedItem)
  func adjustIsLikedState(forFeedItem feedItem: FeedItem)
}
