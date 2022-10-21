//
//  FeedGroupsCoreDataDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import CoreData
import UIKit

class FeedGroupsDataBaseDataSource: LocalDataSource {
  
  var groups: [Group]?
  
  lazy var coreDataStack = CoreDataStack(modelName: "MeedlyData")
  var asyncFetchRequest: NSAsynchronousFetchRequest<Group>?
  var fetchRequest: NSFetchRequest<Group>?
  
  func loadData() -> [Group]? {
//    asyncFetchRequest = NSAsynchronousFetchRequest<Group>(fetchRequest: Group.fetchRequest()) {
//      [unowned self] (result: NSAsynchronousFetchResult) in
//
//      guard let groups = result.finalResult else {
//        return
//      }
//
//      self.groups = groups
//    }
//
//    do {
//      guard let asyncFetchRequest = asyncFetchRequest
//      else {
//        return nil
//      }
//      try coreDataStack.managedContext.execute(asyncFetchRequest)
//
//    } catch let error as NSError {
//      print("Could not fetch \(error), \(error.userInfo)")
//    }
    
    fetchRequest = Group.fetchRequest()
    
    guard let groups = try? coreDataStack.managedContext.fetch(fetchRequest!)
    else {
      return nil
    }
    
    self.groups = groups
    
    //deleting experemental rubbish
    
//    for group in groups {
//      if group.feeds != nil {
//        for feed in group.feeds! {
//          coreDataStack.managedContext.delete(feed)
//        }
//      }
//      if group.chanels != nil {
//        for chanel in group.chanels! {
//          coreDataStack.managedContext.delete(chanel)
//        }
//      }
//      coreDataStack.managedContext.delete(group)
//    }
//    try? coreDataStack.managedContext.save()
    
    return self.groups
  }
  
  func saveNewGroup(_ newGroupName: String) -> Group {
    let group = Group.createNew(withTitle: newGroupName, in: coreDataStack.managedContext)
//    //TEMPORARY UBRAT POTOM!!!
//    Feed.createNew(withTitle: "This111AAAAAAA is very pretty feed, even a little sexual. Sometimes i tihnj I can read every time and everywhere. This is really awesame feeed....", withDescription: "discription", withLink: URL(string: "https://github.com/IlliaPoliakov/Meddly/tree/main/Meedly")!, withImageData: nil, viewed: false, withPubDate: "08.05.2003", in: coreDataStack.managedContext, withhGroup: group)
//    Feed.createNew(withTitle: "This222BBBBBBB is very pretty feed, even a little sexual. Sometimes i tihnj I can read every time and everywhere. This is really awesame feeed....", withDescription: "discription", withLink: URL(string: "https://github.com/IlliaPoliakov/Meddly/tree/main/Meedly")!, withImageData: nil, viewed: false, withPubDate: "08.05.2003", in: coreDataStack.managedContext, withhGroup: group)
//    Feed.createNew(withTitle: "This333CCCCCCCC is very pretty feed, even a little sexual. Sometimes i tihnj I can read every time and everywhere. This is really awesame feeed....", withDescription: "discription", withLink: URL(string: "https://github.com/IlliaPoliakov/Meddly/tree/main/Meedly")!, withImageData: nil, viewed: false, withPubDate: "08.05.2003", in: coreDataStack.managedContext, withhGroup: group)
//
    return group
  }
  
  func saveNewChanel(_ newChanelURl: URL, _ group: Group) {
    FeedChanel.createNew(withTitle: nil, withImageData: nil, withLink: newChanelURl, withGroup: group, in: coreDataStack.managedContext)
  }
}

