//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem: Hashable, Equatable {
  var feedItemDescription: String
  var imageUrl: URL?
  var pubDate: String
  var title: String
  var link: URL
  var isViewed: Bool = false
  
  init(feedItemDescription: String,
       imageUrl: URL? = nil,
       pubDate: String,
       title: String,
       link: URL ) {
    self.feedItemDescription = feedItemDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
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
                                 link: entity.link
                                )
      )
    }
    
    return modelItems
  }
}
