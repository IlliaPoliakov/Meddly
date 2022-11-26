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
  
  private let coreDataManager = AppDelegate.DIContainer.resolve(CoreDataManager.self)!
  
  
  // -MARK: - Functions -
  
  func loadItems(withFeetchRequest fetchRequest: NSFetchRequest<FeedItemEntity>) -> [FeedItemEntity]? {
    let sortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)

    do {
        try fetchedResultsController.performFetch()
    } catch {
        let fetchError = error as NSError
        print("Unable to Save Note")
        print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    
    guard let items = fetchedResultsController.fetchedObjects,
          !items.isEmpty
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return nil
    }
    
    return items
  }
  
  func loadFeeds(withFeetchRequest fetchRequest: NSFetchRequest<FeedEntity>) -> [FeedEntity]? {
    let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: self.coreDataManager.managedObjectContext,
        sectionNameKeyPath: nil,
        cacheName: nil)

    do {
        try fetchedResultsController.performFetch()
    } catch {
        let fetchError = error as NSError
        print("Unable to Save Note")
        print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let feeds = fetchedResultsController.fetchedObjects,
          !feeds.isEmpty
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return nil
    }
    
    return feeds
  }
  
  
  func saveNewFeed(withUrl feedUrl: URL, inGroupWithTitle groupName: String) {
    let newFeed = FeedEntity(context: coreDataManager.managedObjectContext)
    
    newFeed.link = feedUrl
    newFeed.parentGroup = groupName
    
    do {
        try newFeed.managedObjectContext?.save()
    } catch {
        let saveError = error as NSError
        print("Unable to Save Note")
        print("\(saveError), \(saveError.localizedDescription)")
    }
  }
  
  func saveNewItem(_ feedItem: FeedItem) {
    let newItem = FeedItemEntity(context: coreDataManager.managedObjectContext)
    
    newItem.title = feedItem.title
    newItem.link = feedItem.link
    newItem.parentFeed = feedItem.parentFeed
    newItem.parentGroup = feedItem.parentGroup
    newItem.isLiked = feedItem.isLiked
    newItem.isViewed = feedItem.isViewed
    newItem.pubDate = feedItem.pubDate
    newItem.imageUrl = feedItem.imageUrl
    newItem.itemDescription = feedItem.itemDescription
    
    do {
        try newItem.managedObjectContext?.save()
    } catch {
        let saveError = error as NSError
        print("Unable to Save Note")
        print("\(saveError), \(saveError.localizedDescription)")
    }
  }
  
  
  func deleteFeed(withTitle feedTitle: String) {
    let feedsFetchRequest = NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    
    let feedsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(FeedEntity.title), "\(feedTitle)"
    )
    
    let feedsSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
    
    feedsFetchRequest.sortDescriptors = [feedsSortDescriptor]
    feedsFetchRequest.predicate = feedsPredicate
    
    let feedsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: feedsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try feedsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let feeds = feedsFetchedResultsController.fetchedObjects,
          !feeds.isEmpty,
          let feed = feeds.first
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return
    }
    
    coreDataManager.managedObjectContext.delete(feed)
    
    
    let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
        
    let itemsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(FeedItemEntity.parentFeed), "\(feedTitle)"
    )
    
    let itemsSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
    
    itemsFetchRequest.sortDescriptors = [itemsSortDescriptor]
    itemsFetchRequest.predicate = itemsPredicate
    
    let itemsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: itemsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try itemsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let items = itemsFetchedResultsController.fetchedObjects,
          !items.isEmpty
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return
    }

    items.forEach { item in
      coreDataManager.managedObjectContext.delete(item)
    }
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  func deleteGroup(withTitle groupTitle: String) {
    let feedsFetchRequest = NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    
    let feedsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(FeedEntity.parentGroup), "\(groupTitle)"
    )
    
    let feedsSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
    
    feedsFetchRequest.sortDescriptors = [feedsSortDescriptor]
    feedsFetchRequest.predicate = feedsPredicate
    
    let feedsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: feedsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try feedsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let feeds = feedsFetchedResultsController.fetchedObjects,
          !feeds.isEmpty
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return
    }
    
    feeds.forEach { feed in
      if let feedTitle = feed.title {
        self.deleteFeed(withTitle: feedTitle)
      }
    }
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  
  func markAsRead(forTimePeriod timePeriod: TimePeriod) {
    let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    
    let itemsPredicate = NSPredicate(
      format: "%K < %@",
      #keyPath(FeedItemEntity.pubDate),
      Date(timeIntervalSinceNow: -timePeriod.rawValue) as CVarArg)
    
    let itemsSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
    
    itemsFetchRequest.sortDescriptors = [itemsSortDescriptor]
    itemsFetchRequest.predicate = itemsPredicate
    
    let itemsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: itemsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try itemsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let items = itemsFetchedResultsController.fetchedObjects,
          !items.isEmpty
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return
    }
    
    items.forEach { item in
      item.isViewed = true
    }
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  func adjustIsReadState(forFeedItem feedItem: FeedItem) {
    let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    
    let itemsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(FeedItemEntity.title), "\(feedItem.title)")
    
    let itemsSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
    
    itemsFetchRequest.sortDescriptors = [itemsSortDescriptor]
    itemsFetchRequest.predicate = itemsPredicate
    
    let itemsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: itemsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try itemsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let items = itemsFetchedResultsController.fetchedObjects,
          !items.isEmpty,
          let item = items.last
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return
    }
    
    item.isViewed = !item.isViewed
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  func adjustIsLikedState(forFeedItem feedItem: FeedItem) {
    let itemsFetchRequest = NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    
    let itemsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(FeedItemEntity.title), "\(feedItem.title)")
    
    let itemsSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
    
    itemsFetchRequest.sortDescriptors = [itemsSortDescriptor]
    itemsFetchRequest.predicate = itemsPredicate
    
    let itemsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: itemsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try itemsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let items = itemsFetchedResultsController.fetchedObjects,
          !items.isEmpty,
          let item = items.first
    else {
      print("FUCK!!! CoreData items-fetch is failed")
      return
    }
    
    item.isLiked = !item.isLiked
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  func updateFeedEntity(withFeed feed: Feed, forFeedEntity feedEntity: FeedEntity){
    feedEntity.imageUrl = feed.imageUrl
    feedEntity.title = feed.title
    
    try? coreDataManager.managedObjectContext.save()
  }
  
}
