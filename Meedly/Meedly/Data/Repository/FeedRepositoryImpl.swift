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
  
  private var parser = XMLDataParser()
  
  private let localDataSource: DataBaseDataSource
  private let remoteDataSource: NetworkDataSource
  
  init(localDataSource: DataBaseDataSource,
       remoteDataSource: NetworkDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - UseCase Funcs -
  
  func getItems() -> AnyPublisher<Result<[FeedItem], MeedlyError>, Never> {
    let publisher = PassthroughSubject<Result<[FeedItem], MeedlyError>, Never>()
    
    DispatchQueue.global(qos: .userInitiated).async {
      let localFeedItems = self.localDataSource.loadItems(
        withFeetchRequest: FeedItemEntity.fetchRequest())
      
      if let localFeedItems {
        let feedItems = FeedItemEntity.convertToDomain(fromEntities: localFeedItems)
        
        DispatchQueue.main.async {
          publisher.send(.success(feedItems))
        }
      }
      
      let feedEnttities = self.localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      if let feedEnttities {
        feedEnttities.forEach { feedEntity in
          let fetchResult = self.remoteDataSource.fetchData(fromUrl: feedEntity.link)
          
          switch fetchResult {
          case .success(let data):
            let (feed, feedItems) = self.parser.parse(forGroupWithTitle: feedEntity.parentGroup,
                                                      forFeedWithTitle: feedEntity.title,
                                                      data)
            if let feed, feedEntity.title == nil  {
              self.localDataSource.updateFeedEntity(withFeed: feed, forFeedEntity: feedEntity)
            }
            
            if let feedItems {
              feedItems.forEach { feedItem in
                self.localDataSource.saveNewItem(feedItem)
              }
              DispatchQueue.main.async {
                publisher.send(.success(feedItems))
              }
            }
            else {
              DispatchQueue.main.async {
                publisher.send(.failure(.emptyFeed))
              }
            }
            
          case .failure(let error):
            DispatchQueue.main.async {
              publisher.send(.failure(error))
            }
          }
        }
        DispatchQueue.main.async {
          publisher.send(completion: .finished)
        }
      }
    }
    
    return publisher.eraseToAnyPublisher()
  }
  
  func getFeeds() -> AnyPublisher<[Feed], Never> {
    let publisher = PassthroughSubject<[Feed], Never>()
    
    DispatchQueue.global(qos: .userInitiated).async {
      let feedEntities = self.localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      
      if let feedEntities {
        let feeds = FeedEntity.convertToDomain(withEntities: feedEntities)
        DispatchQueue.main.async {
          publisher.send(feeds)
        }
      }
      
      DispatchQueue.main.async {
        publisher.send(completion: .finished)
      }
    }
    
    return publisher.eraseToAnyPublisher()
  }
  
  
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithTitle groupName: String) {
    localDataSource.saveNewFeed(withUrl: feedUrl, inGroupWithTitle: groupName)
  }
  
  
  func deleteFeed(withTitle feedTitle: String) {
    DispatchQueue.global(qos: .background).async {
      self.localDataSource.deleteFeed(withTitle: feedTitle)
    }
  }
  
  func deleteGroup(withTitle groupTitle: String) {
    localDataSource.deleteGroup(withTitle: groupTitle)
  }
  
  
  func markAsRead(forTimePeriod timePeriod: TimePeriod) {
    localDataSource.markAsRead(forTimePeriod: timePeriod)
  }
  func adjustIsReadState(forFeedItem feedItem: FeedItem) {
    localDataSource.adjustIsReadState(forFeedItem: feedItem)
  }
  
  func adjustIsLikedState(forFeedItem feedItem: FeedItem) {
    localDataSource.adjustIsLikedState(forFeedItem: feedItem)
  }

}
