//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem: Hashable {
  var feedDescription: String
  var imageUrl: URL?
  var pubDate: Date
  var title: String
  var link: URL
  var isViewed: Bool
  var isLiked: Bool
  var parentGroup: String
  
  init(feedDescription: String,
       imageUrl: URL?,
       pubDate: Date,
       title: String,
       link: URL,
       isViewed: Bool,
       isLiked: Bool,
       parentGroup: String) {
    self.feedDescription = feedDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
    self.isViewed = isViewed
    self.isLiked = isLiked
    self.parentGroup = parentGroup
  }
}
