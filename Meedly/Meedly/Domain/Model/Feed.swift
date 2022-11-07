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
  
  init(imageUrl: URL?,
       link: URL,
       title: String?,
       id: UUID) {
    self.imageUrl = imageUrl
    self.link = link
    self.title = title
    self.id = id
  }

  static func == (lhs: Feed, rhs: Feed) -> Bool {
    return lhs.link == rhs.link
  }
  
}
