//
//  FeedGroupEntity+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 31.10.22.
//
//

import Foundation
import CoreData

@objc(FeedGroupEntity)
public class FeedGroupEntity: NSManagedObject {
  
  static func convertToModelGroups(withEntities entities:
                                   [FeedGroupEntity]?) -> [FeedGroup]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelGroups = [FeedGroup]()
    
    for entity in entities! {
      modelGroups.append(FeedGroup(title: entity.title,
                                   feeds: FeedEntity
        .convertToModelFeeds(withEntities: entity.feeds),
                                   items: FeedItemEntity
        .convertToModelItems(withEntities: entity.items),
                                   id: entity.id)
      )
    }
    
    return modelGroups
  }
  
}
