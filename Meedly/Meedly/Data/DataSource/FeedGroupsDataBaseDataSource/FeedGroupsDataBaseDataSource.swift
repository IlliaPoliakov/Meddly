//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import UIKit

class FeedGroupsDataBaseDataSource: LocalDataSource {
  
  // -MARK: - Properties -

  let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  
  // -MARK: - Functions -
  
  func loadData() -> [Group]? {
    
    guard let groups = try? managedContext.fetch(Group.fetchRequest()),
          !groups.isEmpty
    else {
      return nil
    }
    
    // clean experemental rubbish

//        for group in groups {
//          if group.feeds != nil {
//            if !(group.feeds!.isEmpty) {
//              for feed in group.feeds! {
//                managedContext.delete(feed)
//              }
//            }
//          }
//          if group.feedChanels != nil {
//            if !(group.feedChanels!.isEmpty) {
//              for chanel in group.feedChanels! {
//                managedContext.delete(chanel)
//              }
//            }
//          }
//          managedContext.delete(group)
//        }
//        try? managedContext.save()
    
    return groups
  }
  
  func saveNewGroup(_ newGroupName: String) -> Group {
    return Group.createNew(withTitle: newGroupName, in: managedContext)
  }
  
  func saveNewChanel(_ newChanelUrl: URL, _ group: Group) {
    FeedChanel.createNew(withTitle: nil, withImageData: nil, withLink: newChanelUrl, withGroup: group, in: managedContext)
  }
}

