//
//  NetworkDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 17.10.22.
//

import Foundation

protocol RemoteDataSource {
  func downloadData(withUrl url: URL, _ completion: @escaping (Data?, String?) -> Void)
  func downloadImageData(withUrl url: URL, _ completion: @escaping (Data?) -> Void)
}

protocol LocalDataSource {
  func loadData() -> [FeedGroupEntity]?
  func saveNewGroup(withNewGroupName name: String) -> FeedGroupEntity
  func saveNewFeed(withNewFeedUrl url: URL, withParentGroup group: FeedGroupEntity)
  func saveNewFeedItem(withTitle title: String,
                       withDescription feedDescription: String,
                       withLink link: URL,
                       withImageData imageData: Data?,
                       withPubDate pubDate: String,
                       withhGroup group: FeedGroupEntity)
}
