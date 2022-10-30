//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem: Hashable {
  var feedItemDescription: String
  var imageUrl: URL?
  var pubDate: String
  var title: String
  var link: URL
  var parentGroup: FeedGroup
  var isViewed: Bool = false
  
  init(feedItemDescription: String,
       imageUrl: URL? = nil,
       pubDate: String,
       title: String,
       link: URL,
       parentGroup: FeedGroup) {
    self.feedItemDescription = feedItemDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
    self.parentGroup = parentGroup
  }
}
