//
//  Feed.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct Feed {
  public var id: UUID
  public var imageData: Data?
  public var link: URL
  public var title: String?
  public var parentGroup: FeedGroup
  
  init(id: UUID, imageData: Data? = nil, link: URL, title: String? = nil, parentGroup: FeedGroup) {
    self.id = id
    self.imageData = imageData
    self.link = link
    self.title = title
    self.parentGroup = parentGroup
  }
}
