//
//  XMLParser.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation
import UIKit

class XMLDataParser: NSObject, XMLParserDelegate {
  
  // -MARK: - Properties -
  
  let defaultImageUrl: URL = URL(string:"https://cdn.i.haymarketmedia.asia/?n=campaign-asia%2Fcontent%2FcroppedF1logo.png&h=570&w=855&q=100&v=20170226&c=1")!

  var elementName: String? = nil
  //feed item data
  var itemtitle: String = ""
  var itemDescription: String = ""
  var itemLink: String = ""
  var pubDate: String = ""
  var itemImageUrl: String = ""
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
      itemImageUrl = attributeDict["url"] ?? ""
    }
    
    self.elementName = elementName
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if (!data.isEmpty) {
      switch self.elementName {
      case "title":
        self.itemtitle += data
      case "link":
        self.itemLink += data
      case "pubDate":
        self.pubDate += data
      case "content:encoded":
        self.itemDescription += data
      default:
        break
      }
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String,
              namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "item" {
      let item = FeedItem(feedItemDescription: itemDescription.html2String,
                          imageUrl: URL(string: itemImageUrl) ?? defaultImageUrl,
                          pubDate: pubDate.replacingOccurrences(of: "+0000",with: ""),
                          title: itemtitle,
                          link: URL(string: itemLink)!)
      feedItems.append(item)
    }
  }
  
  func getFeedItems() -> [FeedItem]? {
    return feedItems
  }
}