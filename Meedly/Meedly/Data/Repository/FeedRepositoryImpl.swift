//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Combine

class FeedRepositoryImpl: FeedRepository {
  
  // -MARK: - Properties -
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let localDataSource: DataBaseDataSource
  private let remoteDataSource: NetworkDataSource
  
  init(localDataSource: DataBaseDataSource,
       remoteDataSource: NetworkDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - UseCase Funcs -
  
  func getItems()/* -> AnyPublisher<[FeedItem]?, MeedlyError> */{
    localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      .sink(receiveCompletion: { _ in },
            receiveValue: { feeds in
        guard let feeds
        else {
          return
        }
        
      
      }).store(in: &subscriptions)
    
    
    localDataSource.loadItems(withFeetchRequest: FeedItemEntity.fetchRequest())
      .sink(receiveCompletion: { _ in },
            receiveValue: { items in
        
      }).store(in: &subscriptions)
    
    Publishers.ReceiveOn(
      upstream: localDataSource.loadFeeds( withFeetchRequest: FeedEntity.fetchRequest()),
      scheduler: DispatchQueue.global(qos: .userInitiated),
      options: nil)
    
    
  }
  
  func getFeeds() -> AnyPublisher<[Feed]?, MeedlyError> {
    
  }
  
  
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithTitle groupName: String) {
    localDataSource.saveNewFeed(withUrl: feedUrl, inGroupWithTitle: groupName)
  }
  
  
  func deleteFeed(withTitle feedTitle: String) {
    localDataSource.deleteFeed(withTitle: feedTitle)
  }
  
  func deleteGroup(withTitle groupTitle: String) {
    localDataSource.deleteGroup(withTitle: groupTitle)
  }
  
  
  func adjustIsReadState(forFeedItem feedItem: FeedItem?, forTimePeriod timePeriod: TimePeriod?) {
    localDataSource.adjustIsReadState(forFeedItem: feedItem, forTimePeriod: timePeriod)
  }
  
  func adjustIsLikedState(forFeedItem feedItem: FeedItem) {
    localDataSource.adjustIsLikedState(forFeedItem: feedItem)
  }

}
