//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation


class FeedRepositoryImpl: FeedRepository {
  
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
  
  func getFeedGroups(_ completion:
                     @escaping ([FeedGroup]?, String?) -> Void) {
    var savedErrorMessage: String? = nil
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      var groups = self?.localDataSource.loadData()
      
      DispatchQueue.main.async {
        completion(FeedGroup.convertToModelGroups(withEntities: groups), nil)
      }
      
      let downloadGroup = DispatchGroup()
      
      if Connectivity.isConnectedToInternet() {
        for group in groups! {
          if group.feeds != nil {
            for feed in group.feeds! {
              downloadGroup.enter()
              
              self?.remoteDataSource.downloadData(withUrl: feed.link) {
                [weak self] data, error in
                if data != nil {
                  let parser = XMLParser(data: data!)
                  parser.delegate = self?.xmlParserDelegate
                  parser.parse()
                  
                  let feeds = self?.xmlParserDelegate.getFeeds()
                  
                  for feed in feeds! {
                    if !(group.feeds?.contains(where: { $0.title == feed.title}) ?? false) {
                      self?.localDataSource
                        .saveNewFeedItem(withTitle: feed.title,
                                         withDescription: feed.feedItemDescription,
                                         withLink: feed.link,
                                         withImageUrl: feed.imageUrl!,
                                         withPubDate: feed.pubDate,
                                         withGroup: group)
                    }
                  }
                }
                savedErrorMessage = error
              }
              
              downloadGroup.leave()
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
        groups = self?.localDataSource.loadData()
        completion(FeedGroup.convertToModelGroups(withEntities: groups), savedErrorMessage)
      }
    }
  }
  
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroup {
    let newGroup = localDataSource.saveNewGroup(withNewGroupName: newGroupName)
    
    return FeedGroup.convertToModelGroups(withEntities: [newGroup])!.first!
  }
  
  func saveNewFeed(_ newChanelUrl: URL, _ group: FeedGroup) {
    
    let groupEntity = localDataSource.getPredicatedGroup(withGroup: group)
    localDataSource.saveNewFeed(withNewFeedUrl: newChanelUrl, withParentGroup: groupEntity!)
  }
  
}
