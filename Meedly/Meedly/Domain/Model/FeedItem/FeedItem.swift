//
//  FeedItem.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct FeedItem {
  public var feedItemDescription: String
  public var imageData: Data?
  public var pubDate: String
  public var title: String
  public var link: URL
  public var parentGroup: FeedGroupEntity
  
  init(feedItemDescription: String, imageData: Data? = nil, pubDate: String, title: String, link: URL, parentGroup: FeedGroupEntity) {
    self.feedItemDescription = feedItemDescription
    self.imageData = imageData
    self.pubDate = pubDate
    self.title = title
    self.link = link
    self.parentGroup = parentGroup
  }
}
