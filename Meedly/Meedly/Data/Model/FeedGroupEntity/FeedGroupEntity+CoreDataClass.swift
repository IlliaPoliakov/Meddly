//
//  FeedGroupEntity+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 10.11.22.
//
//

import Foundation
import CoreData

@objc(FeedGroupEntity)
public class FeedGroupEntity: NSManagedObject {
  static func convertToDomainGroups(withEntities entities:
                                    [FeedGroupEntity]?) -> [FeedGroup]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelGroups = [FeedGroup]()
    
    for entity in entities! {
      if !entity.isFault {
        modelGroups.append(FeedGroup(title: entity.title,
                                     feeds: FeedEntity
          .convertToDomainFeeds(withEntities: entity.feeds),
                                     items: FeedItemEntity
          .convertToDomainItems(withEntities: entity.items),
                                     id: entity.id)
        )
      }
    }
    
    return modelGroups
  }
}
