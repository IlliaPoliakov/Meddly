//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import Combine

class DataBaseDataSource {
  
  // -MARK: - Properties -
  
  let coreDataStack = AppDelegate.DIContainer.resolve(CoreDataStack.self)!
  
  
  // -MARK: - Functions -
  
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
    let group = getPredicatedGroup(withGroupTitle: item.parentGroupTitle)
    let groupItem = group!.items?.filter { $0.title == item.title }
    groupItem!.first!.isViewed = true
    coreDataStack.saveContext()
    DispatchQueue.global(qos: .userInitiated).async {
      let group = self.getPredicatedGroup(withGroupTitle: item.parentGroupTitle)
      let groupItem = group!.items?.filter { $0.title == item.title }
      groupItem!.first!.isViewed = true
      self.coreDataStack.saveContext()
    }
  }
  
  
  func markAsReadedOld(forTimePeriod timePeriod: String){
    let groups = self.loadData()
    
    var groupItems = [FeedItemEntity]()
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "HH:mm E, d MMM y"
    
    for group in groups! {
      if group.items != nil {
        switch timePeriod {
        case "One Hour":
          groupItems.append(contentsOf: group.items!.filter { item in
            let hourBeforeNow = Calendar.current.date(byAdding: .hour,
                                                      value: 0,
                                                      to: .now)
            if hourBeforeNow! > formatter.date(from: item.pubDate)! {
              return true
            }
            return false
          })
          
        case "One Day":
          groupItems.append(contentsOf: group.items!.filter { item in
            let dayBeforeNow = Calendar.current.date(byAdding: .day,
                                                     value: -1,
                                                     to: .now)
            if dayBeforeNow! > formatter.date(from: item.pubDate)! {
              return true
            }
            return false
          })
        case "One Week":
          groupItems.append(contentsOf: group.items!.filter { item in
            let weekBeforeNow = Calendar.current.date(byAdding: .weekOfMonth,
                                                      value: 0,
                                                      to: .now)
            if weekBeforeNow! > formatter.date(from: item.pubDate)! {
              return true
            }
            return false
          })
        case "One Month":
          groupItems.append(contentsOf: group.items!.filter { item in
            let monthBeforeNow = Calendar.current.date(byAdding: .month,
                                                       value: 0,
                                                       to: .now)
            if monthBeforeNow! > formatter.date(from: item.pubDate)! {
              return true
            }
            return false
          })
        default:
          break
        }
      }
    }
    
    guard !groupItems.isEmpty
    else {
      return
    }
    for groupItem in groupItems {
      groupItem.isViewed = true
    }
    
    try? self.coreDataStack.managedContext.save()
  }
  
  
  func deleteFeed(forFeed feed: Feed) {
    let groups = self.loadData()
    let group = groups?.first { $0.feeds != nil && $0.feeds!.contains {
      $0.title == feed.title
    }}
    
    let items = group!.items?.filter { $0.parentFeedLink == feed.link}
    guard items != nil
    else {
      return
    }
    
    for item in items! {
      self.coreDataStack.managedContext.delete(item)
    }
    
    let feed = group!.feeds!.first { $0.title == feed.title}
    self.coreDataStack.managedContext.delete(feed!)
    
    try? self.coreDataStack.managedContext.save()
    
  }
  
  func deleteGroup(forGroup group: FeedGroup) {
    DispatchQueue.global().async {
      let group = self.getPredicatedGroup(withGroupTitle: group.title)
      
      if group?.feeds != nil {
        for feed in group!.feeds! {
          self.coreDataStack.managedContext.delete(feed)
        }
      }
      if group?.items != nil {
        for item in group!.items! {
          self.coreDataStack.managedContext.delete(item)
        }
      }
      
      self.coreDataStack.managedContext.delete(group!)
      
      try? self.coreDataStack.managedContext.save()
    }
  }
}
