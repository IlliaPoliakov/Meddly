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
  
  func getItems() -> AnyPublisher<Result<[FeedItem]?, MeedlyError>, Never> {
    let localPublisher = localDataSource.loadItems(withFeetchRequest: FeedItemEntity.fetchRequest())
      .flatMap { items in

        items.publisher
      }
    
    let remotePublisher = localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      .map { feeds -> Result<[FeedItem]?, MeedlyError> in
        guard let feeds
        else {
          return .failure(.cachedDataIsEmpty)
        }
        
        feeds.forEach { feed in
          
        }
      }
      
    
    return Publishers.Merge(localPublisher, remotePublisher)
  }
  
  func getFeeds() -> AnyPublisher<[Feed]?, Never> {
    localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      .map { feeds in
        FeedEntity.convertToDomain(withEntities: feeds)
      }
      .eraseToAnyPublisher()
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
