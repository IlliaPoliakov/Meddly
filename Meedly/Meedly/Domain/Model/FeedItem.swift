//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation
import UIKit

struct FeedItem: Identifiable, Equatable, Hashable {
  var feedItemDescription: String
  var imageUrl: URL?
  var pubDate: String
  var title: String
  var link: URL
  var isViewed: Bool
  var id: UUID
  var parentGroupTitle: String
  
  init(feedItemDescription: String,
       imageUrl: URL? = nil,
       pubDate: String,
       title: String,
       link: URL,
       id: UUID,
       isViewed: Bool,
       parentGroupTitle: String) {
    self.feedItemDescription = feedItemDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
    self.id = id
    self.isViewed = isViewed
    self.parentGroupTitle = parentGroupTitle
  }
  
  static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
