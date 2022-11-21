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
    let localPublisher = localDataSource.loadItems(withFeetchRequest: FeedItemEntity.fetchRequest())
      .compactMap { feedItemEntities in // get rid of nil, unwrap not-nil and cast to model
        FeedItemEntity.convertToDomain(fromEntities: feedItemEntities)
      }
      .map{ feedItems -> Result<[FeedItem], MeedlyError> in //cast to Result<...,...>
        var result: Result<[FeedItem], MeedlyError>
        result = .success(feedItems)
        
        return result
      }
      .eraseToAnyPublisher()
    
    
    let remotePublisher = localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      .compactMap { feedEntities in // get rid of nil and unwrap not-nil
        return feedEntities
      }
      .flatMap { feedEntityes -> Publishers.Sequence in
        return feedEntityes.publisher
      }
      .map { feedEntity -> Result<[FeedItem], MeedlyError> in
        var result: Result<[FeedItem], MeedlyError> //return value
        let fetchResult = self.remoteDataSource.fetchData(fromUrl: feedEntity.link) // 1. fetch data from net
        
        switch fetchResult {
        case .success(let data):
          let (feed, feedItems) = self.parser.parse(forGroupWithTitle: feedEntity.parentGroup,
                                                    forFeedWithTitle: feedEntity.title,
                                                    data) // 2. parse given data
          
          if let feed, feedEntity.title == nil  { // 3. update feed if needed
            self.localDataSource.updateFeedEntity(withFeed: feed, forFeedEntity: feedEntity)
          }
          
          if let feedItems {
            feedItems.forEach { feedItem in
              self.localDataSource.saveNewItem(feedItem)
            }
            
            result = .success(feedItems)
          }
          else {
            result = .failure(.emptyFeed)
          }

        case .failure(let error):
          result = .failure(error)
        }
        
        return result
      }
      .eraseToAnyPublisher()
      
    
    return localPublisher.merge(with: remotePublisher).eraseToAnyPublisher()
  }
  
  func getFeeds() -> AnyPublisher<[Feed], Never> {
    localDataSource.loadFeeds(withFeetchRequest: FeedEntity.fetchRequest())
      .compactMap { feedEntities in // get rid of nil and unwrap not-nil
        return feedEntities
      }
      .map { feedEntities in
        FeedEntity.convertToDomain(withEntities: feedEntities) ?? [Feed]()
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
