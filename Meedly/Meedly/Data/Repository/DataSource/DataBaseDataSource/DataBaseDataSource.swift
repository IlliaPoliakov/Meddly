//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import UIKit

class DataBaseDataSource {
  
  // -MARK: - Properties -
  
  let coreDataStack = AppDelegate.DIContainer.resolve(CoreDataStack.self)!
  
  
  // -MARK: - Functions -
  
  func cleanData() {
    let groups = loadData()
    guard groups != nil
    else {
      return
    }
    for group in groups! {
      if group.items != nil {
        for item in group.items! {
          coreDataStack.managedContext.delete(item)
        }
      }
      if group.feeds != nil {
        for feed in group.feeds! {
          coreDataStack.managedContext.delete(feed)
        }
      }
      coreDataStack.managedContext.delete(group)
    }
    try? coreDataStack.managedContext.save()
  }
  
  func getPredicatedGroup(withGroupTitle groupTitle: String) -> FeedGroupEntity? {
    
    let predicate = NSPredicate(format: "%K == %@",
                                #keyPath(FeedGroupEntity.title), "\(groupTitle)")
    
    let fetchRequest =
    NSFetchRequest<FeedGroupEntity>(entityName: "FeedGroupEntity")
    fetchRequest.resultType = .managedObjectResultType
    fetchRequest.predicate = predicate
    guard let group = try? coreDataStack.managedContext.fetch(fetchRequest)
    else {
      return nil
    }
    
    return group.first
  }
  
  func loadData() -> [FeedGroupEntity]? {
    
    guard var groups = try? coreDataStack.managedContext.fetch(FeedGroupEntity.fetchRequest())
    else {
      return nil
    }
    
    if groups.isEmpty {
      let group = saveNewGroup(withNewGroupName: "Default Group")
      groups.append(group)
    }
    
    return groups
  }
  
  func saveNewGroup(withNewGroupName name: String) -> FeedGroupEntity {
    let group = FeedGroupEntity.init(context: coreDataStack.managedContext)
    
    group.title = name
    group.id = UUID()
    
    coreDataStack.saveContext()
    
    return group
  }
  
  func saveNewFeed(withNewFeedUrl url: URL, withParentGroup group: FeedGroupEntity) {
    let newFeed = FeedEntity.init(context: coreDataStack.managedContext)
    
    newFeed.link = url
    newFeed.id = UUID()
    newFeed.parentGroup = group
    
    group.addToFeeds(newFeed)
    
    coreDataStack.saveContext()
  }
  
  func saveNewFeedItem(withTitle title: String,
                       withDescription feedDescription: String,
                       withLink link: URL,
                       withImageUrl imageUrl: URL?,
                       withPubDate pubDate: String,
                       withGroup group: FeedGroupEntity,
                       withParentFeedLink parentFeedLink: URL) {
    
    let newFeedItem = FeedItemEntity.init(context: coreDataStack.managedContext)
    newFeedItem.title = title
    newFeedItem.feedItemDescription = feedDescription
    newFeedItem.link = link
    newFeedItem.imageUrl = imageUrl
    newFeedItem.pubDate = pubDate
    newFeedItem.parentGroup = group
    newFeedItem.id = UUID()
    newFeedItem.parentFeedLink = parentFeedLink
    
    group.addToItems(newFeedItem)
    
    coreDataStack.saveContext()
  }
  
  func markAsReaded(forFeedItem item: FeedItem){
    DispatchQueue.global(qos: .userInitiated).async {
      let group = self.getPredicatedGroup(withGroupTitle: item.parentGroupTitle)
      let groupItem = group!.items?.filter { $0.title == item.title }
      groupItem!.first!.isViewed = true
      self.coreDataStack.saveContext()
    }
  }
  
  func deleteFeed(forFeed feed: Feed) {
    DispatchQueue.global().async {
      let groups = self.loadData()
      let poorGroup = groups?.first { $0.feeds != nil && $0.feeds!.contains {
        $0.title == feed.title
      }}
      
      let poorFeed = poorGroup!.feeds!.first { $0.title == feed.title}
      self.coreDataStack.managedContext.delete(poorFeed!)
      
      let poorItems = poorGroup!.items?.filter { $0.parentFeedLink == feed.link}
      guard poorItems != nil
      else {
        return
      }
      
      for item in poorItems! {
        self.coreDataStack.managedContext.delete(item)
      }
    }
  }
  
  func deleteGroup(forGroup group: FeedGroup) {
    DispatchQueue.global().async {
      let poorGroup = self.getPredicatedGroup(withGroupTitle: group.title)
      self.coreDataStack.managedContext.delete(poorGroup!)
      try? self.coreDataStack.managedContext.save()
    }
  }
  
  func saveContext(){
    coreDataStack.saveContext()
  }
}
