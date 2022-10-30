//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation


class FeedRepositoryImpl: FeedRepository {
  func getFeedGroups(_ completion: @escaping ([FeedGroup]?, String?) -> Void) {
    <#code#>
  }
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroup {
    <#code#>
  }
  
  func saveNewFeed(_ newFeedURL: URL, _ group: FeedGroup) {
    <#code#>
  }
  
  
  // -MARK: - Properties -
  
  public static var shared: FeedRepository = FeedRepositoryImpl(localDataSource: AppDelegate.DIContainer.resolve(LocalDataSource.self)!, remoteDataSource: AppDelegate.DIContainer.resolve(RemoteDataSource.self)!)
  
  private let localDataSource: LocalDataSource
  private let remoteDataSource: RemoteDataSource
  
  private var xmlParserDelegate = XMLDataParser()//no needed DI?
  
  init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - Functional -
  
  func getFeedGroups(_ completion: @escaping ([FeedGroupEntity]?, String?) -> Void) {
    
    DispatchQueue.global(qos: .userInteractive){
      let groups = localDataSource.loadData()
      
      DispatchQueue.main.async {
        completion(groups, nil)
      }
      
      let downloadGroup = DispatchGroup()
      
      if Connectivity.isConnectedToInternet() {
        for group in groups! {
          if group.feeds != nil {
            for feed in group.feeds! {
              downloadGroup.enter()
              
              remoteDataSource.downloadData(withUrl: feed.link) { [weak self] data, error in
                if data != nil {
                  let parser = XMLParser(data: data!)
                  parser.delegate = self?.xmlParserDelegate
                  parser.parse()
                  
                  let feeds = self?.xmlParserDelegate.getFeeds() { [weak self] in
                    self?.remoteDataSource.downloadImageData(
                      withUrl: modelFeed.imageUrl!) { fetchedImageData in
                        
                        let newFeedItem = self?.localDataSource
                          .saveNewFeedItem(withTitle: modelFeed.title,
                                           withDescription: modelFeed.feedItemDescription,
                                           withLink: modelFeed.link, withImageData: fetchedImageData,
                                           withPubDate: modelFeed.pubDate, withhGroup: group)
                        
                      }
                  }
                }
                self?.errorMessage = error
                
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
        completion(self.groups, self.errorMessage)
      }
    }
  }
  
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroupEntity {
    let newGroup = localDataSource.saveNewGroup(withNewGroupName: newGroupName)
    if groups == nil {
      groups = [newGroup]
    }
    else {
      groups?.append(newGroup)
    }
    return newGroup
  }
  
  func saveNewFeed(_ newChanelUrl: URL, _ group: FeedGroupEntity) {
    localDataSource.saveNewFeed(withNewFeedUrl: newChanelUrl, withParentGroup: group)
  }
}
