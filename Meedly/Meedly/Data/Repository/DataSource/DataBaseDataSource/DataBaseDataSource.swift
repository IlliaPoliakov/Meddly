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
    
    guard let groups =
            try? coreDataStack.managedContext.fetch(FeedGroupEntity.fetchRequest()),
          !groups.isEmpty
    else {
      return nil
    }
    
    // clean experemental rubbish
    
    //        for group in groups {
    //          if group.feeds != nil {
    //            if !(group.feeds!.isEmpty) {
    //              for feed in group.feeds! {
    //                managedContext.delete(feed)
    //              }
    //            }
    //          }
    //          if group.feedChanels != nil {
    //            if !(group.feedChanels!.isEmpty) {
    //              for chanel in group.feedChanels! {
    //                managedContext.delete(chanel)
    //              }
    //            }
    //          }
    //          managedContext.delete(group)
    //        }
    //        try? managedContext.save()
    
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
    let feed = FeedEntity.init(context: coreDataStack.managedContext)
    
    feed.link = url
    feed.id = UUID()
    feed.parentGroup = group
    
    coreDataStack.saveContext()
  }
  
  func saveNewFeedItem(withTitle title: String,
                       withDescription feedDescription: String,
                       withLink link: URL,
                       withImageData imageData: Data?,
                       withPubDate pubDate: String,
                       withhGroup group: FeedGroupEntity) {
    
    let newFeed = FeedItemEntity.init(context: coreDataStack.managedContext)
    newFeed.title = title
    newFeed.feedItemDescription = feedDescription
    newFeed.link = link
    newFeed.imageData = imageData
    newFeed.pubDate = pubDate
    newFeed.parentGroup = group
    newFeed.id = UUID()
    
    coreDataStack.saveContext()
  }
  
}
