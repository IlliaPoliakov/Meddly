//
//  Group.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedGroup: Identifiable, Equatable, Hashable {
  public var id: UUID
  public var title: String
  public var feeds: [Feed]?
  public var items: [FeedItem]?
  
  init(title: String = "", feeds: [Feed]? = nil, items: [FeedItem]? = nil, id: UUID = UUID()) {
    self.title = title
    self.feeds = feeds
    self.items = items
    self.id = id
  }
  
  static func == (lhs: FeedGroup, rhs: FeedGroup) -> Bool {
    return lhs.feeds == rhs.feeds && lhs.items == rhs.items && lhs.title == rhs.title
  }
  
  static func convertToModelGroups(withEntities entities:
                                   [FeedGroupEntity]?) -> [FeedGroup]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelGroups = [FeedGroup]()
    
    for entity in entities! {
      modelGroups.append(FeedGroup(title: entity.title,
                                   feeds: Feed.convertToModelFeeds(withEntities: entity.feeds),
                                   items: FeedItem.convertToModelItems(withEntities: entity.items),
                                   id: entity.id
                                  )
      )
    }
    
    return modelGroups
  }
}
