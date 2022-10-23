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

  let coreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack // EXPEREMENT, DONT FORGET
  
  
  // -MARK: - Functions -
  
  func loadData() -> [FeedGroup]? {
    
    guard let groups = try? coreDataStack.managedContext.fetch(FeedGroup.fetchRequest()),
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
  
  func saveNewGroup(withNewGroupName name: String) -> FeedGroup {
    let group = FeedGroup.init(context: coreDataStack.managedContext)
    
    group.title = name
    group.id = UUID()
    
    coreDataStack.saveContext()
    
    return group
  }
  
  func saveNewFeed(withNewFeedUrl url: URL, withParentGroup group: FeedGroup) {
    let feed = Feed.init(context: coreDataStack.managedContext)
    
    feed.link = url
    feed.id = UUID()
    feed.parentGroup = group
    
    coreDataStack.saveContext()
  }
}
