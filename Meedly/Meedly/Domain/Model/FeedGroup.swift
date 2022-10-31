//
//  Group.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedGroup: Hashable, Equatable {
  public var id: UUID
  public var title: String
  public var feeds: [Feed]?
  public var items: [FeedItem]?
  
  init(id: UUID = UUID(), title: String = "", feeds: [Feed]? = nil, items: [FeedItem]? = nil) {
    self.id = id
    self.title = title
    self.feeds = feeds
    self.items = items
  }
  
  static func convertToModelGroups(withEntities entities:
                                   [FeedGroupEntity]?) -> [FeedGroup]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelGroups = [FeedGroup]()
    
    for entity in entities! {
      modelGroups.append(FeedGroup(id: UUID(),
                                   title: entity.title,
                                   feeds: Feed.convertToModelFeeds(withEntities: entity.feeds),
                                   items: FeedItem.convertToModelItems(withEntities: entity.items)))
    }
    
    return modelGroups
  }
}
