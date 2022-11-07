//
//  FeedEntity+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 31.10.22.
//
//

import Foundation
import CoreData

@objc(FeedEntity)
public class FeedEntity: NSManagedObject {
  static func convertToModelFeeds(withEntities entities:
                                   [FeedEntity]?) -> [Feed]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelFeeds = [Feed]()
    
    for entity in entities! {
      modelFeeds.append(Feed(imageUrl: entity.imageUrl,
                             link: entity.link,
                             title: entity.title,
                             id: entity.id
                             )
      )
    }
    
    return modelFeeds
  }
}
