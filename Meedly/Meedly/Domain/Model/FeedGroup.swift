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
  
  init(title: String = "",
       feeds: [Feed]?,
       items: [FeedItem]?,
       id: UUID) {
    self.title = title
    self.feeds = feeds
    self.items = items
    self.id = id
  }
  
  static func == (lhs: FeedGroup, rhs: FeedGroup) -> Bool {
    return lhs.feeds == rhs.feeds && lhs.items == rhs.items && lhs.title == rhs.title
  }

}
