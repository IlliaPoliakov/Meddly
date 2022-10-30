//
//  Feed.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct Feed: Hashable {
  var id: UUID
  var imageData: Data?
  var link: URL
  var title: String?
  var parentGroup: FeedGroup
  
  init(id: UUID, imageData: Data? = nil, link: URL, title: String? = nil, parentGroup: FeedGroup) {
    self.id = id
    self.imageData = imageData
    self.link = link
    self.title = title
    self.parentGroup = parentGroup
  }
  
  static func == (lhs: Feed, rhs: Feed) -> Bool {
    return lhs.id == rhs.id
  }
}
