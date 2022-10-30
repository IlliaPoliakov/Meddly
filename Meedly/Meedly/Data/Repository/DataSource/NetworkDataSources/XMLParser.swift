//
//  XMLParser.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation

class XMLDataParser: NSObject, XMLParserDelegate {
  
  // -MARK: - Properties -

  var elementName: String? = nil
  //feed item data
  var itemtitle: String? = nil
  var itemDescription: String? = nil
  var itemLink: String? = nil
  var pubDate: String? = nil
  var itemImageUrl: String? = nil
  // feed chanel data
  var feedTitle: String? = nil
  var feedImageUrl: String? = nil
  
  var feedItems = [FeedItem]()
  
  
  // -MARK: - Functions -
  
  func parser(_ parser: XMLParser, didStartElement elementName: String,
              namespaceURI: String?, qualifiedName qName: String?,
              attributes attributeDict: [String : String] = [:]) {
    
    if elementName == "item" {
      itemtitle = ""
      itemDescription = ""
      itemLink = ""
      pubDate = ""
      itemImageUrl = ""
    }
    
    if elementName == "media:thumbnail" {
      itemImageUrl = attributeDict["url"]
    }
    
    self.elementName = elementName
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if (!data.isEmpty) {
      switch self.elementName {
      case "title":
        self.itemtitle! += data
      case "link":
        self.itemLink! += data
      case "pubDate":
        self.pubDate! += data
      case "content:encoded":
        self.itemDescription! += data
      default:
        break
      }
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String,
              namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "item" {
      let item = FeedItem(feedItemDescription: itemDescription,
                          imageUrl: URL(string: itemImageUrl)!,
                          pubDate: pubDate, title: itemtitle,
                          link: URL(string: link)!)
      feedItems.append(item)
    }
  }
  
  func getFeeds() -> [FeedItem]? {
    return feedItems
  }
}
