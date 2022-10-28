//
//  XMLParser.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation

class XMLDataParser: NSObject, XMLParserDelegate {
  
  // -MARK: - Properties -
  var group: FeedGroupEntity
  var feed: FeedEntity
  
  init(group: FeedGroupEntity, feed: FeedEntity) {
    self.group = group
    self.feed = feed
  }
  
  var itemtitle: String? = nil
  var itemDescription: String? = nil
  var link: URL? = nil
  var pubDate: String? = nil
  var imageData: Data? = nil
  
  var feedTitle: String? = nil
  var feedImageData: Data? = nil
  
  
  // -MARK: - Functions -
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    if feed.title == nil {
      switch elementName {
      case "title": feedTitle = attributeDict["jopa"]
      default: break
      }
    }
  }
}
