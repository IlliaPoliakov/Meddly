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
  
  init(localDataSource: DataBaseDataSource,
       remoteDataSource: NetworkDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - UseCase func-s -
  
  func getFeedGroups(updateState state: UpdateState,
                     _ completion: @escaping ([FeedGroup]?, String?) -> Void) {
    var savedErrorMessage: String? = nil
    
    DispatchQueue.global(qos: .userInitiated).async {
      
      var groups = self.localDataSource.loadData()
      
      if state == .regularUpdate {
        DispatchQueue.main.async {
          completion(FeedGroupEntity.convertToDomainGroups(withEntities: groups), nil)
        }
      }
      
      let downloadGroup = DispatchGroup()
      
      if Connectivity.isConnectedToInternet() {
        for group in groups! {
          if group.feeds != nil {
            for groupFeed in group.feeds! {
              
              downloadGroup.enter()
              
              self.remoteDataSource.downloadData(withUrl: groupFeed.link) {
                [weak self] data, error in
                
                if data != nil {
                  let parser = FeedParser(data: data!)
                  let resultFeed = parser.parse()
                  
                  switch resultFeed {
                  case .success(let success):
                    
                    switch success {
                      
                    case .atom(let atomFeed):
                      groupFeed.title = atomFeed.title ?? "[no title]"
                      groupFeed.imageUrl = atomFeed.icon != nil ? URL(string: atomFeed.icon!) :
                      nil
//                    groupFeed.imageUrl = atomFeed.logo != nil ? URL(string: atomFeed.logo!) :
//                    nil
                      if atomFeed.entries != nil {
                        for entry in atomFeed.entries! {

                          let date: String = entry.published == nil ? "[no date]" :
                          DateFormatter().string(from: entry.published!)

                          let description: String = entry.summary?.value?.html2String ??
                          "[no description]"

                          let imageUrl = entry.media?.mediaThumbnails?.first?.value != nil ?
                          URL(string: entry.media!.mediaThumbnails!.first!.value!) : nil

                          let link: URL = URL(string: entry.links!.first!.attributes!.href!)!

                          if !(group.items?.contains(where: { $0.title == entry.title}) ?? false) {

                            self?.localDataSource
                              .saveNewFeedItem(withTitle: entry.title ?? "[no title]",
                                               withDescription: description,
                                               withLink: link,
                                               withImageUrl: imageUrl,
                                               withPubDate: date,
                                               withGroup: group)
                          }

                        }
                      }
                      
                    case .json(let jsonFeed):
                      groupFeed.title = jsonFeed.title ?? "[no title]"
                      groupFeed.imageUrl = jsonFeed.icon != nil ? URL(string: jsonFeed.icon!) : nil
                      if jsonFeed.items != nil {
                        for item in jsonFeed.items! {

                          let imageUrl = item.image != nil ? URL(string: item.image!) : nil

                          let date = item.datePublished == nil ? "[no date]" :
                          DateFormatter().string(from: item.datePublished!)
                          if !(group.items?.contains(where: { $0.title == item.title}) ?? false) {
                            self?.localDataSource
                              .saveNewFeedItem(withTitle: item.title ?? "[no title]",
                                               withDescription: item.summary ?? "[no descripiton]",
                                               withLink: URL(string: item.url!)!,
                                               withImageUrl: imageUrl,
                                               withPubDate: date,
                                               withGroup: group)
                          }
                        }
                      }
                      
                    case .rss(let rssFeed):
                      groupFeed.title = rssFeed.title
                      groupFeed.imageUrl = rssFeed.image?.url != nil ?
                      URL(string: (rssFeed.image?.url)!) : nil
                      if rssFeed.items != nil {
                        for item in rssFeed.items! {
                          
                          let imageUrl = item.media?.mediaThumbnails?.first?.attributes?.url != nil ? URL(string: item.media!.mediaThumbnails!.first!.attributes!.url!) : nil

                          let date: String
                          let formatter = DateFormatter()
//                          formatter.dateFormat = "HH:mm E, d MMM y"
                          date = item.pubDate != nil ? formatter.string(from: item.pubDate!) :
                          "[no pubDate]"
                          if !(group.items?.contains(where: { $0.title == item.title}) ?? false) {
                            self?.localDataSource
                              .saveNewFeedItem(withTitle: item.title ?? "[no title]",
                                               withDescription: item.content?.contentEncoded?.html2String ?? "[no description]",
                                               withLink: URL(string: item.link!)!,
                                               withImageUrl: imageUrl,
                                               withPubDate: date,
                                               withGroup: group)
                          }
                        }
                      }
                    default:
                      break
                    }
                    
                    
                  case .failure(let failure):
                    savedErrorMessage = failure.errorDescription
                  }
                  
                  savedErrorMessage = error
                  
                  downloadGroup.leave()
                }
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
        completion(FeedGroupEntity.convertToDomainGroups(withEntities: groups),
                   savedErrorMessage)
      }
    }
  }
  
  func saveNewGroup(_ newGroupName: String) -> FeedGroup {
    let newGroup = localDataSource.saveNewGroup(withNewGroupName: newGroupName)
    
    return FeedGroupEntity.convertToDomainGroups(withEntities: [newGroup])!.first!
  }
  
  func saveNewFeed(_ newFeedUrl: URL, _ group: FeedGroup) {
    
    let groupEntity = localDataSource.getPredicatedGroup(withGroup: group)
    localDataSource.saveNewFeed(withNewFeedUrl: newFeedUrl, withParentGroup: groupEntity!)
  }
  
}
