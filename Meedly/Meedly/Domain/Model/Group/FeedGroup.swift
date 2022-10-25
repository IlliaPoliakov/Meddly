//
//  Group.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedGroup {
  public var id: UUID
  public var title: String
  public var feeds: [Feed]?
  public var items: [FeedItem]?
  
  init(id: UUID, title: String, feeds: [Feed]? = nil, items: [FeedItem]? = nil) {
    self.id = id
    self.title = title
    self.feeds = feeds
    self.items = items
  }
}
