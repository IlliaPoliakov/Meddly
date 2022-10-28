//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import UIKit

class DataBaseDataSource: LocalDataSource {
  
  // -MARK: - Properties -
  
  let coreDataStack = AppDelegate.DIContainer.resolve(CoreDataStack.self)!
  
  
  // -MARK: - Functions -
  
  func loadData() -> [FeedGroupEntity]? {
    
    guard var groups = try? coreDataStack.managedContext.fetch(FeedGroupEntity.fetchRequest())
    else {
      return nil
    }
    
    // clean experemental rubbish
    
//    for group in groups {
//      if group.items != nil {
//        if !(group.items!.isEmpty) {
//          for item in group.items! {
//            coreDataStack.managedContext.delete(item)
//          }
//        }
//      }
//      if group.feeds != nil {
//        if !(group.feeds!.isEmpty) {
//          for feed in group.feeds! {
//            coreDataStack.managedContext.delete(feed)
//          }
//        }
//      }
//      coreDataStack.managedContext.delete(group)
//    }
//    try? coreDataStack.managedContext.save()
    
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
                       withImageData imageData: Data?,
                       withPubDate pubDate: String,
                       withhGroup group: FeedGroupEntity) {
    
    let newFeedItem = FeedItemEntity.init(context: coreDataStack.managedContext)
    newFeedItem.title = title
    newFeedItem.feedItemDescription = feedDescription
    newFeedItem.link = link
    newFeedItem.imageData = imageData
    newFeedItem.pubDate = pubDate
    newFeedItem.parentGroup = group
    newFeedItem.id = UUID()
    group.addToItems(newFeedItem)
    
    coreDataStack.saveContext()
  }
}
