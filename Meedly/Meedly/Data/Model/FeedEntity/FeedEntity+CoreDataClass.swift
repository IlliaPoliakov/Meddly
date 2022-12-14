//
//  FeedEntity+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//
//

import Foundation
import CoreData

@objc(FeedEntity)
public class FeedEntity: NSManagedObject {
  
  static func convertToDomainFeeds(withEntities entities: [FeedEntity]?) -> [Feed]? {
    guard entities != nil
    else {
      return nil
    }
    
    return entities!.map { entity in
      Feed(imageUrl: entity.imageUrl, link: entity.link,
           title: entity.title, parentGroup: entity.parentGroup)
    }
  }
  
}
