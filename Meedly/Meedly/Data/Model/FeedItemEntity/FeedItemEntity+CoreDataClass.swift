//
//  FeedItemEntity+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 8.11.22.
//
//

import Foundation
import CoreData

@objc(FeedItemEntity)
public class FeedItemEntity: NSManagedObject {
  static func convertToDomainItems(withEntities entities:
                                  [FeedItemEntity]?) -> [FeedItem]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelItems = [FeedItem]()
    
    for entity in entities! {
      modelItems.append(FeedItem(feedItemDescription: entity.feedItemDescription,
                                 imageUrl: entity.imageUrl,
                                 pubDate: entity.pubDate,
                                 title: entity.title,
                                 link: entity.link,
                                 id: entity.id,
                                 isViewed: entity.isViewed,
                                 parentGroupTitle: entity.parentGroup!.title)
      )
    }
    
    return modelItems
  }
}
