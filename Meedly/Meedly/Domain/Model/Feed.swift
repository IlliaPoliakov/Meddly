//
//  Feed.swift
//  Meedly
//
//  Created by Illia Poliakov on 24.10.22.
//

import Foundation

struct Feed: Hashable {
  var imageUrl: URL?
  var link: URL
  var title: String?
  var parentGroup: String
  
  init(imageUrl: URL?,
       link: URL,
       title: String?,
       parentGroup: String) {
    self.imageUrl = imageUrl
    self.link = link
    self.title = title
    self.parentGroup = parentGroup
  }
}
