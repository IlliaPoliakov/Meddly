//
//  Feed.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct Feed: Identifiable, Equatable, Hashable {
  var id: UUID
  var imageUrl: URL?
  var link: URL
  var title: String?
  
  init(imageUrl: URL? = nil,
       link: URL,
       title: String? = nil,
       id: UUID = UUID()) {
    self.imageUrl = imageUrl
    self.link = link
    self.title = title
    self.id = id
  }

  static func == (lhs: Feed, rhs: Feed) -> Bool {
    return lhs.link == rhs.link
  }
  
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
