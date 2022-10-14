//
//  FeedGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation

protocol FeedGroupsRepository {
  func getFeedGroups() -> [Group] 
}
