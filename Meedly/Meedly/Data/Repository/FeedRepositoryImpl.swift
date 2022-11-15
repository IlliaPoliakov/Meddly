//
//  FeedGroupRepositoryImpl.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import FeedKit
import Combine


class FeedRepositoryImpl: FeedRepository {
  
  // -MARK: - Properties -
  
  private let localDataSource: DataBaseDataSource
  private let remoteDataSource: NetworkDataSource
  
  init(localDataSource: DataBaseDataSource,
       remoteDataSource: NetworkDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  
  // -MARK: - UseCase funcs -
  
  func getFeedGroups(updateState state: UpdateState) -> PassthroughSubject<FeedGroup, Never> {
    let publisher = PassthroughSubject<FeedGroup, Never>()
    
    
    return publisher
  }
  
  func getFeedGroups(updateState state: UpdateState,
                     _ completion: @escaping ([FeedGroup]?, String?) -> Void) {
    var savedErrorMessage: String? = nil
    
    DispatchQueue.global(qos: .userInitiated).async {
      
      var groups = self.localDataSource.loadData()
      
      if state == .initialUpdate || state == .localUpdate {
        DispatchQueue.main.async {
          completion(FeedGroupEntity.convertToDomainGroups(withEntities: groups), nil)
        }
        if state == .localUpdate {
          return
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
                      groupFeed.imageUrl = atomFeed.logo != nil ? URL(string: atomFeed.logo!) :
                      nil
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
                            if !groupFeed.isFault {
                              self?.localDataSource
                                .saveNewFeedItem(withTitle: entry.title ?? "[no title]",
                                                 withDescription: description,
                                                 withLink: link,
                                                 withImageUrl: imageUrl,
                                                 withPubDate: date,
                                                 withGroup: group,
                                                 withParentFeedLink: groupFeed.link)
                            }
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
                            if !groupFeed.isFault {
                              self?.localDataSource
                                .saveNewFeedItem(withTitle: item.title ?? "[no title]",
                                                 withDescription: item.summary ?? "[no descripiton]",
                                                 withLink: URL(string: item.url!)!,
                                                 withImageUrl: imageUrl,
                                                 withPubDate: date,
                                                 withGroup: group,
                                                 withParentFeedLink: groupFeed.link)
                            }
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
                          formatter.locale = Locale(identifier: "en_US_POSIX")
                          formatter.dateFormat = "HH:mm E, d MMM y"
                          date = item.pubDate != nil ? formatter.string(from: item.pubDate!) :
                          "[no pubDate]"
                          
                          let description: String
                          let contentDiscp = item.content?.contentEncoded?.html2String ?? "[no description]"
                          let descriptionDescp = item.description?.html2String ?? "[no description]"
                          description = contentDiscp.count >= descriptionDescp.count ?
                          contentDiscp : descriptionDescp
                          
                          if !(group.items?.contains(where: { $0.title == item.title}) ?? false) {
                            if !groupFeed.isFault {
                              self?.localDataSource
                                .saveNewFeedItem(withTitle: item.title ?? "[no title]",
                                                 withDescription: description,
                                                 withLink: URL(string: item.link!)!,
                                                 withImageUrl: imageUrl,
                                                 withPubDate: date,
                                                 withGroup: group,
                                                 withParentFeedLink: groupFeed.link)
                            }
                          }
                        }
                      }
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
          completion( FeedGroupEntity.convertToDomainGroups(withEntities: groups), "No enternet connection...")
        }
      }
      
      downloadGroup.wait()
      
      DispatchQueue.main.async {
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
    let groupEntity = localDataSource.getPredicatedGroup(withGroupTitle: group.title)
    localDataSource.saveNewFeed(withNewFeedUrl: newFeedUrl, withParentGroup: groupEntity!)
  }
  
  func markAsReadedOld(forTimePeriod timePeriod: String) {
    localDataSource.markAsReadedOld(forTimePeriod: timePeriod)
  }
  
  func markAsReaded(feedItem item: FeedItem) {
    localDataSource.markAsReaded(forFeedItem: item)
  }

  
  func deleteFeed(forFeed feed: Feed) {
    localDataSource.deleteFeed(forFeed: feed)
  }
  
  func deleteGroup(forGroup group: FeedGroup) {
    localDataSource.deleteGroup(forGroup: group)
  }
  
}
