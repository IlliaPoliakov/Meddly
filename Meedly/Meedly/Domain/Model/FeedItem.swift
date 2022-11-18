//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem: Hashable {
  var itemDescription: String
  var imageUrl: URL?
  var pubDate: Date
  var title: String
  var link: URL
  var isViewed: Bool
  var isLiked: Bool
  var parentGroup: String
  var parentFeed: String
  
  init(itemDescription: String,
       imageUrl: URL?,
       pubDate: Date,
       title: String,
       link: URL,
       isViewed: Bool,
       isLiked: Bool,
       parentFeed: String,
       parentGroup: String) {
    self.itemDescription = itemDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
    self.isViewed = isViewed
    self.isLiked = isLiked
    self.parentGroup = parentGroup
    self.parentFeed = parentFeed
  }
}
