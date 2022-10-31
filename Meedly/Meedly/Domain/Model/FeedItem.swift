//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem: Identifiable, Equatable, Hashable {
  var feedItemDescription: String
  var imageUrl: URL?
  var pubDate: String
  var title: String
  var link: URL
  var isViewed: Bool = false
  var id: UUID
  
  init(feedItemDescription: String,
       imageUrl: URL? = nil,
       pubDate: String,
       title: String,
       link: URL,
       id: UUID = UUID()) {
    self.feedItemDescription = feedItemDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
    self.id = id
  }
  
  static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
    return lhs.link == rhs.link
  }

  static func convertToModelItems(withEntities entities:
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
                                 id: entity.id
                                )
      )
    }
    
    return modelItems
  }
}