//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem {
  public var feedItemDescription: String
  public var imageUrl: URL?
  public var pubDate: String
  public var title: String
  public var link: URL
  
  init(feedItemDescription: String, imageUrl: URL? = nil,
       pubDate: String, title: String, link: URL) {
    self.feedItemDescription = feedItemDescription
    self.imageUrl = imageUrl
    self.pubDate = pubDate
    self.title = title
    self.link = link
  }
}
