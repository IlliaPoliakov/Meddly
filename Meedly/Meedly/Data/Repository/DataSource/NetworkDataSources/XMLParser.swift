//
//  XMLParser.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//

import Foundation

class XMLDataParser: NSObject, XMLParserDelegate {
  
  // -MARK: - Properties -

  var elementName: String = ""
  //feed item data
  var itemtitle: String = ""
  var itemDescription: String = ""
  var link: URL? = nil
  var linkString: String = ""
  var pubDate: String = ""
  var itemImageDataUrl: String = ""
  // feed chanel data
  var feedTitle: String = ""
  var feedImageData: Data? = nil
  
  var feedItems = [FeedItem]()
  
  var checkImage: Bool = false
  
  
  // -MARK: - Functions -
  
  func parser(_ parser: XMLParser, didStartElement elementName: String,
              namespaceURI: String?, qualifiedName qName: String?,
              attributes attributeDict: [String : String] = [:]) {
    
    if elementName == "item" {
      itemtitle = ""
      itemDescription = ""
      link = nil
      linkString = ""
      pubDate = ""
      itemImageDataUrl = ""
    }
    
    if elementName == "media:thumbnail" {
      itemImageDataUrl = attributeDict["url"] ?? "" // MB errors due to non-nil
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
        self.linkString += data
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
      let item = FeedItem(feedItemDescription: itemDescription,
                          imageUrl: URL(string: itemImageDataUrl)!,
                          pubDate: pubDate, title: itemtitle,
                          link: URL(string: linkString)!)
      feedItems.append(item)
    }
  }
  
  func getFeeds() -> [FeedItem]? {
    return feedItems
  }
}
