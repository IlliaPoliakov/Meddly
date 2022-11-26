//
//  FeedItemEntity+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//
//

import Foundation
import CoreData

@objc(FeedItemEntity)
public class FeedItemEntity: NSManagedObject {
  
  static func convertToDomain(fromEntities entities: [FeedItemEntity]) -> [FeedItem] {
    return entities.map { entity in
      FeedItem(itemDescription: entity.itemDescription,
               imageUrl: entity.imageUrl,
               pubDate: entity.pubDate,
               title: entity.title,
               link: entity.link,
               isViewed: entity.isViewed,
               isLiked: entity.isLiked,
               parentFeed: entity.parentFeed,
               parentGroup: entity.parentGroup)
    }
  }
}
