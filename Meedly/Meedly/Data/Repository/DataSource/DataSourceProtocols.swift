//
//  NetworkDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 17.10.22.
//

import Foundation

protocol RemoteDataSource {}

protocol LocalDataSource {
  func loadData() -> [FeedGroup]?
  func saveNewGroup(withNewGroupName name: String) -> FeedGroup
  func saveNewFeed(withNewFeedUrl url: URL, withParentGroup group: FeedGroup)
}
