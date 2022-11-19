//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import Combine

final class DataBaseDataSource {
  
  // -MARK: - Dependencies -
  
  private let coreDataStack = AppDelegate.DIContainer.resolve(CoreDataStack.self)!
  
  
  // -MARK: - Functions -
  
  func loadItems(withFeetchRequest fetchRequest: NSFetchRequest<FeedItemEntity>) ->
  Deferred<Future<[FeedItemEntity]?, Never>> {
    
    return Deferred {
      Future { completion in
        guard let items = try? self.coreDataStack.managedContext.fetch(fetchRequest)
        else {
          print("CoreData fetch is failed")
          completion(.success(nil))
          return
        }
        
        completion(.success(items.isEmpty ? nil : items))
      }
    }
  }
  
  func loadFeeds(withFeetchRequest fetchRequest: NSFetchRequest<FeedEntity>) ->
  Deferred<Future<[FeedEntity]?, Never>> {
    
    return Deferred {
      Future { completion in
        guard let feeds = try? self.coreDataStack.managedContext.fetch(fetchRequest)
        else {
          print("CoreData fetch is failed")
          completion(.success(nil))
          return
        }
        
        completion(.success(feeds.isEmpty ? nil : feeds))
      }
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
    // first fetch and delete specific feed
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
    
    // last fetch an delete specific items
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
    // fetch and delete feeds with given parent group
    let feedsPredicate = NSPredicate(format: "%K == %@",
                                     #keyPath(FeedEntity.parentGroup), "\(groupTitle)")
    let feedsFetchRequest = NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    feedsFetchRequest.resultType = .managedObjectResultType
    feedsFetchRequest.predicate = feedsPredicate
    
    var subscription: AnyCancellable?
    subscription = self.loadFeeds(withFeetchRequest: feedsFetchRequest).sink(
      receiveCompletion: {_ in
        subscription?.cancel()
      },
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
      
      var subscription: AnyCancellable?
      subscription = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
        receiveCompletion: {_ in
          subscription?.cancel()
        },
        receiveValue: { items in
          guard let item = items?.first
          else {
            return
          }
          
          item.isViewed = !item.isViewed
        }
      )
    }
    else if let timePeriod { // dont sure how predicate will work
      let itemsPredicate = NSPredicate(format: "%K < %@",
                                       #keyPath(FeedItemEntity.pubDate),
                                       "\(Date(timeIntervalSinceNow: timePeriod.rawValue))")
      let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
      itemsFetchRequest.resultType = .managedObjectResultType
      itemsFetchRequest.predicate = itemsPredicate
      
      var subscription: AnyCancellable?
      subscription = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
        receiveCompletion: {_ in
          subscription?.cancel()
        },
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
    
    var subscription: AnyCancellable?
    subscription = self.loadItems(withFeetchRequest: itemsFetchRequest).sink(
      receiveCompletion: { _ in
        subscription?.cancel()
      },
      receiveValue: { items in
        guard let item = items?.first
        else {
          return
        }
        
        item.isLiked = !item.isLiked
      }
    )
    
    self.coreDataStack.saveContext()
  }
  
  func updateFeedEntity(withFeed feed: Feed, forFeedEntity feedEntity: FeedEntity){
    feedEntity.imageUrl = feed.imageUrl
    feedEntity.title = feed.title
    
    self.coreDataStack.saveContext()
  }
  
}
