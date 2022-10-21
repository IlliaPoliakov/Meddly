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
  
  lazy var coreDataStack = CoreDataStack(modelName: "MeedlyDataModel")
  
  
  
  // -MARK: - Functions -
  
  func loadData() -> [Group]? {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    guard let groups = try? managedContext.fetch(Group.fetchRequest()),
          !groups.isEmpty
    else {
      return nil
    }
    
//        for group in groups {
//          if group.feeds != nil {
//            if !(group.feeds!.isEmpty) {
//              for feed in group.feeds! {
//                coreDataStack.managedContext.delete(feed)
//              }
//            }
//          }
//          if group.feedChanels != nil {
//            if !(group.feedChanels!.isEmpty) {
//              for chanel in group.feedChanels! {
//                coreDataStack.managedContext.delete(chanel)
//              }
//            }
//          }
//          coreDataStack.managedContext.delete(group)
//        }
//        try? coreDataStack.managedContext.save()
    
    return groups
  }
  
  func saveNewGroup(_ newGroupName: String) -> Group {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let group = Group.createNew(withTitle: newGroupName, in: managedContext)
    
    //            TEMPORARY UBRAT POTOM!!!
    Feed.createNew(withTitle: "This111AAAAAAA is very pretty feed, even a little sexual. Sometimes i tihnj I can read every time and everywhere. This is really awesame feeed....", withDescription: "discription", withLink: URL(string: "https://github.com/IlliaPoliakov/Meddly/tree/main/Meedly")!, withImageData: nil, withPubDate: "08.05.2003", in: managedContext, withhGroup: group)
    //    Feed.createNew(withTitle: "This222BBBBBBB is very pretty feed, even a little sexual. Sometimes i tihnj I can read every time and everywhere. This is really awesame feeed....", withDescription: "discription", withLink: URL(string: "https://github.com/IlliaPoliakov/Meddly/tree/main/Meedly")!, withImageData: nil, withPubDate: "08.05.2003", in: coreDataStack.managedContext, withhGroup: group)
    //    Feed.createNew(withTitle: "This333CCCCCCCC is very pretty feed, even a little sexual. Sometimes i tihnj I can read every time and everywhere. This is really awesame feeed....", withDescription: "discription", withLink: URL(string: "https://github.com/IlliaPoliakov/Meddly/tree/main/Meedly")!, withImageData: nil, withPubDate: "08.05.2003", in: coreDataStack.managedContext, withhGroup: group)
    //    FeedChanel.createNew(withTitle: nil, withImageData: nil, withLink: URL(string: "GitHub.com")!, withGroup: group, in: coreDataStack.managedContext)
    
    
    return group
  }
  
  func saveNewChanel(_ newChanelUrl: URL, _ group: Group) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    FeedChanel.createNew(withTitle: nil, withImageData: nil, withLink: newChanelUrl, withGroup: group, in: managedContext)
  }
}

