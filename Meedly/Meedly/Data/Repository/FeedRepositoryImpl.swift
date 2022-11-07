//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import FeedKit


class FeedRepositoryImpl: FeedRepository {
  
  // -MARK: - Properties -
  
  private let localDataSource: DataBaseDataSource
  private let remoteDataSource: NetworkDataSource
  
  private let xmlParserDelegate: XMLDataParser
  
  init(localDataSource: DataBaseDataSource,
       remoteDataSource: NetworkDataSource,
       xmlParserDelegate: XMLDataParser) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
    self.xmlParserDelegate = xmlParserDelegate
  }
  
  
  // -MARK: - UseCase func-s -
  
  func getFeedGroups(updateState state: UpdateState,
                     _ completion: @escaping ([FeedGroup]?, String?) -> Void) {
    var savedErrorMessage: String? = nil
    
    DispatchQueue.global(qos: .userInitiated).async {
      
      var groups = self.localDataSource.loadData()
      
      if state == .regularUpdate {
        DispatchQueue.main.async {
          completion(FeedGroupEntity.convertToModelGroups(withEntities: groups), nil)
        }
      }
      
      let downloadGroup = DispatchGroup()
      
      if Connectivity.isConnectedToInternet() {
        for group in groups! {
          if group.feeds != nil {
            for feed in group.feeds! {
              
              downloadGroup.enter()
              
              self.remoteDataSource.downloadData(withUrl: feed.link) {
                [weak self] data, error in
                
                if data != nil {
                  let parserTmp = FeedParser(data: data!)
                  
                  let parser = XMLParser(data: data!)
                  parser.delegate = self?.xmlParserDelegate
                  parser.parse()
                  let rssFeed: RSSFeed
                  
                  let items = self?.xmlParserDelegate.getFeedItems()
                  
                  for item in items! {
                    if !(group.items?.contains(where: { $0.title == item.title}) ?? false) {
                      self?.localDataSource
                        .saveNewFeedItem(withTitle: item.title,
                                         withDescription: item.feedItemDescription,
                                         withLink: item.link,
                                         withImageUrl: item.imageUrl!,
                                         withPubDate: item.pubDate,
                                         withGroup: group)
                    }
                  }
                }
                savedErrorMessage = error
                
                downloadGroup.leave()
              }
            }
          }
        }
      }
      else {
        DispatchQueue.main.async {
          completion( nil, "No enternet connection...")
        }
      }
      
      downloadGroup.notify(queue: DispatchQueue.main) {
        groups = self.localDataSource.loadData()
        completion(FeedGroupEntity.convertToModelGroups(withEntities: groups), savedErrorMessage)
      }
    }
  }
  
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroup {
    let newGroup = localDataSource.saveNewGroup(withNewGroupName: newGroupName)
    
    return FeedGroupEntity.convertToModelGroups(withEntities: [newGroup])!.first!
  }
  
  func saveNewFeed(_ newChanelUrl: URL, _ group: FeedGroup) {
    
    let groupEntity = localDataSource.getPredicatedGroup(withGroup: group)
    localDataSource.saveNewFeed(withNewFeedUrl: newChanelUrl, withParentGroup: groupEntity!)
  }
  
}
