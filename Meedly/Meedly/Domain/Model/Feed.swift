//
//  Feed.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct Feed: Hashable {
  var id: UUID
  var imageUrl: URL?
  var link: URL
  var title: String?
  
  init(id: UUID,
       imageUrl: URL? = nil,
       link: URL,
       title: String? = nil ) {
    self.id = id
    self.imageUrl = imageUrl
    self.link = link
    self.title = title
  }
  
  static func == (lhs: Feed, rhs: Feed) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func convertToModelFeeds(withEntities entities:
                                   [FeedEntity]?) -> [Feed]? {
    guard entities != nil
    else {
      return nil
    }
    
    var modelFeeds = [Feed]()
    
    for entity in entities! {
      modelFeeds.append(Feed(id: entity.id,
                             imageUrl: entity.imageUrl,
                             link: entity.link,
                             title: entity.title
                             )
      )
    }
    
    return modelFeeds
  }
  
}
