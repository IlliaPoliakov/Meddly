//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import Combine

class DataBaseDataSource {
  
  // -MARK: - Dependencies -
  
  let coreDataStack = AppDelegate.DIContainer.resolve(CoreDataStack.self)!
  
  
  // -MARK: - Functions -
  
  func loadItems(withFeetchRequest fetchRequest: NSFetchRequest<FeedItemEntity>) ->
  Future<[FeedItemEntity]?, MeedlyError> {
    
    return Future { completion in
      guard let items = try? self.coreDataStack.managedContext.fetch(fetchRequest)
      else {
        completion(.failure(.coreDataFetchFailure))
        return
      }
      
      completion(.success(items.isEmpty ? nil : items))
    }
  }
  
  func loadFeeds(withFeetchRequest fetchRequest: NSFetchRequest<FeedEntity>) ->
  Future<[FeedEntity]?, MeedlyError> {
    
    return Future { completion in
      guard let feeds = try? self.coreDataStack.managedContext.fetch(fetchRequest)
      else {
        completion(.failure(.coreDataFetchFailure))
        return
      }
      
      completion(.success(feeds.isEmpty ? nil : feeds))
    }
  }
  
  
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithTitle groupName: String) {
    let newFeed = FeedEntity.init(context: coreDataStack.managedContext)
    
    newFeed.link = feedUrl
    newFeed.parentGroup = groupName
    
    coreDataStack.saveContext()
  }
  
  func saveNewItem(_ feedItem: FeedItem) {
    let newItem = FeedItemEntity.init(context: coreDataStack.managedContext)
    
    newItem.title = feedItem.title
    newItem.link = feedItem.link
    newItem.parentFeed = feedItem.parentFeed
    newItem.parentGroup = feedItem.parentGroup
    newItem.isLiked = feedItem.isLiked
    newItem.isViewed = feedItem.isViewed
    newItem.pubDate = feedItem.pubDate
    newItem.imageUrl = feedItem.imageUrl
    newItem.itemDescription = feedItem.itemDescription
    
    coreDataStack.saveContext()
  }
  
  
  func deleteFeed(withTitle feedTitle: String) {
    let feedsPredicate = NSPredicate(format: "%K == %@",
                                     #keyPath(FeedEntity.title), "\(feedTitle)")
    let feedsFetchRequest = NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    feedsFetchRequest.resultType = .managedObjectResultType
    feedsFetchRequest.predicate = feedsPredicate
    
    _ = self.loadFeeds(withFeetchRequest: feedsFetchRequest).sink(
      receiveCompletion: {_ in }, // mb need error handling
      receiveValue: { feeds in
        guard let feed = feeds?.first
        else {
          return
        }
        
        self.coreDataStack.managedContext.delete(feed)
      }
    )
    
    let itemsPredicate = NSPredicate(format: "%K == %@",
                                     #keyPath(FeedItemEntity.parentFeed), "\(feedTitle)")
    let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    itemsFetchRequest.resultType = .managedObjectResultType
    itemsFetchRequest.predicate = itemsPredicate
    
    _ = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
      receiveCompletion: {_ in }, // mb need error handling
      receiveValue: { items in
        guard let items
        else {
          return
        }
        
        items.forEach { item in
          self.coreDataStack.managedContext.delete(item)
        }
      }
    )
    
    self.coreDataStack.saveContext()
  }
  
  func deleteGroup(withTitle groupTitle: String) {
    let feedsPredicate = NSPredicate(format: "%K == %@",
                                     #keyPath(FeedEntity.parentGroup), "\(groupTitle)")
    let feedsFetchRequest = NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    feedsFetchRequest.resultType = .managedObjectResultType
    feedsFetchRequest.predicate = feedsPredicate
    
    _ = self.loadFeeds(withFeetchRequest: feedsFetchRequest).sink(
      receiveCompletion: {_ in }, // mb need error handling
      receiveValue: { feeds in
        guard let feeds
        else {
          return
        }
        feeds.forEach { feed in
          if let feedTitle = feed.title {
            self.deleteFeed(withTitle: feedTitle)
          }
        }
      }
    )
    
    self.coreDataStack.saveContext()
  }
  
  
  func adjustIsReadState(forFeedItem feedItem: FeedItem?, forTimePeriod timePeriod: TimePeriod?) {
    if let feedItem {
      let itemsPredicate = NSPredicate(format: "%K == %@",
                                       #keyPath(FeedItemEntity.parentFeed), "\(feedItem.title)")
      let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
      itemsFetchRequest.resultType = .managedObjectResultType
      itemsFetchRequest.predicate = itemsPredicate
      
      _ = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
        receiveCompletion: {_ in }, // mb need error handling
        receiveValue: { items in
          guard let item = items?.first
          else {
            return
          }
          
          item.isViewed = !item.isViewed
        }
      )
    }
    else if let timePeriod { // dont sure how it will work
      let itemsPredicate = NSPredicate(format: "%K < %@",
                                       #keyPath(FeedItemEntity.pubDate),
                                       "\(Date(timeIntervalSinceNow: timePeriod.rawValue))")
      let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
      itemsFetchRequest.resultType = .managedObjectResultType
      itemsFetchRequest.predicate = itemsPredicate
      
      _ = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
        receiveCompletion: {_ in }, // mb need error handling
        receiveValue: { items in
          guard let items
          else {
            return
          }
          
          items.forEach { item in
            item.isViewed = true
          }
        }
      )
    }
    
    self.coreDataStack.saveContext()
  }
  
  func adjustIsLikedState(forFeedItem feedItem: FeedItem) {
    let itemsPredicate = NSPredicate(format: "%K == %@",
                                     #keyPath(FeedItemEntity.parentFeed), "\(feedItem.title)")
    let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    itemsFetchRequest.resultType = .managedObjectResultType
    itemsFetchRequest.predicate = itemsPredicate
    
    _ = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
      receiveCompletion: {_ in }, // mb need error handling
      receiveValue: { items in
        guard let item = items?.first
        else {
          return
        }
        
        item.isLiked = !item.isLiked
      }
    )
    
  }
}
