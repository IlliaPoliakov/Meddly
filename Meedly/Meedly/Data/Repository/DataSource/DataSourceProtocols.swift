//
//  NetworkDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 17.10.22.
//

import Foundation

protocol RemoteDataSource {
  func downloadData(withUrl url: URL, _ completion: @escaping (Data?, String?) -> Void)
}

protocol LocalDataSource {
  func getPredicatedGroup(withGroup group: FeedGroup) -> FeedGroupEntity?
  func loadData() -> [FeedGroupEntity]?
  func saveNewGroup(withNewGroupName name: String) -> FeedGroupEntity
  func saveNewFeed(withNewFeedUrl url: URL, withParentGroup group: FeedGroupEntity)
  func saveNewFeedItem(withTitle title: String,
                       withDescription feedDescription: String,
                       withLink link: URL,
                       withImageUrl imageUrl: URL,
                       withPubDate pubDate: String,
                       withGroup group: FeedGroupEntity)
}
