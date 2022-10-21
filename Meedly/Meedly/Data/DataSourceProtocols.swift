//
//  NetworkDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 17.10.22.
//

import Foundation

protocol RemoteDataSource {}

protocol LocalDataSource {
  func loadData() -> [Group]?
  func saveNewGroup(_ newGroupName: String) -> Group
  func saveNewChanel(_ newChanelUrl: URL, _ group: Group)
}
