//
//  XMLDataParser.swift
//  Meedly
//
//  Created by Illia Poliakov on 19.11.22.
//

import Foundation
import FeedKit

final class XMLDataParser {
  
  func parse(forGroupWithTitle groupTitle: String, forFeedWithTitle feedTitle: String?, _ data: Data)
  -> (Feed?, [FeedItem]?){
    var feed: Feed = Feed(imageUrl: nil,
                          link: URL(string: DefautlModelProperty.link.rawValue)!,
                          title: nil,
                          parentGroup: groupTitle)
    var items = [FeedItem]()
    
    let parser = FeedParser(data: data)
    let resultFeed = parser.parse()
    
    switch resultFeed {
    case .success(let success):
      switch success {
      case .atom(let atomFeed):
        // sett feed
        feed.title = atomFeed.title ?? DefautlModelProperty.title.rawValue
        feed.imageUrl = atomFeed.icon != nil ?
        URL(string: atomFeed.icon!) : nil // or URL(string: atomFeed.logo!)
        // set items
        if let atomItems = atomFeed.entries {
          for item in atomItems {
            let pubDate: Date = item.published ?? Date(timeIntervalSince1970: 0)
            
            let description: String = item.summary?.value?.html2String ??
            DefautlModelProperty.description.rawValue
            
            let imageUrl = item.media?.mediaThumbnails?.first?.value != nil ?
            URL(string: item.media!.mediaThumbnails!.first!.value!) : nil
            
            let link: URL = item.links?.first?.attributes?.href != nil ?
            URL(string: item.links!.first!.attributes!.href!)! :
            URL(string: DefautlModelProperty.link.rawValue)!
            
            let title = item.title ?? DefautlModelProperty.title.rawValue
            
            items.append(FeedItem(itemDescription: description,
                                  imageUrl: imageUrl,
                                  pubDate: pubDate,
                                  title: title,
                                  link: link,
                                  isViewed: false,
                                  isLiked: false,
                                  parentFeed: feed.title!,
                                  parentGroup: groupTitle))
          }
        }
        
        
      case .json(let jsonFeed):
        // set feed
        feed.title = jsonFeed.title ?? DefautlModelProperty.title.rawValue
        feed.imageUrl = jsonFeed.icon != nil ? URL(string: jsonFeed.icon!)! : nil
        // set items
        if let jsonItems = jsonFeed.items {
          for item in jsonItems {
            let imageUrl = item.image != nil ? URL(string: item.image!) : nil
            
            let pubDate = item.datePublished ?? Date(timeIntervalSince1970: 0)
            
            let description: String = item.summary ?? DefautlModelProperty.description.rawValue
            
            let link: URL = item.url != nil ?
            URL(string: item.url!)! :
            URL(string: DefautlModelProperty.link.rawValue)!
            
            let title = item.title ?? DefautlModelProperty.title.rawValue
                
            items.append(FeedItem(itemDescription: description,
                                  imageUrl: imageUrl,
                                  pubDate: pubDate,
                                  title: title,
                                  link: link,
                                  isViewed: false,
                                  isLiked: false,
                                  parentFeed: feed.title!,
                                  parentGroup: groupTitle))
          }
        }
        
        
      case .rss(let rssFeed):
        // set feed
        feed.title = rssFeed.title
        feed.imageUrl = rssFeed.image?.url != nil ? URL(string: rssFeed.image!.url!) : nil
        // set items
        if let rssItems = rssFeed.items {
          for item in rssItems {
            let imageUrl = item.media?.mediaThumbnails?.first?.attributes?.url != nil ?
            URL(string: item.media!.mediaThumbnails!.first!.attributes!.url!) : nil
            
            let pubDate = item.pubDate ?? Date(timeIntervalSince1970: 0)
            
            let link: URL = item.link != nil ?
            URL(string: item.link!)! :
            URL(string: DefautlModelProperty.link.rawValue)!
            
            let description: String
            let contentDescription = item.content?.contentEncoded?.html2String ??
            DefautlModelProperty.description.rawValue
            let descriptionDescription = item.description?.html2String ??
            DefautlModelProperty.description.rawValue
            description = contentDescription.count >= descriptionDescription.count ?
            contentDescription : descriptionDescription
            
            let title = item.title ?? DefautlModelProperty.title.rawValue
            
            items.append(FeedItem(itemDescription: description,
                                  imageUrl: imageUrl,
                                  pubDate: pubDate,
                                  title: title,
                                  link: link,
                                  isViewed: false,
                                  isLiked: false,
                                  parentFeed: feed.title!,
                                  parentGroup: groupTitle))
          }
        }
      }
      
      
    case .failure:
      return (nil, nil)
    }
    
    return (feed, items)
  }
}
