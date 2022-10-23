//
//  FeedGroup+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData

@objc(FeedGroup)
public class FeedGroup: NSManagedObject {
  static func createNew(withTitle title: String,
                        in managedObjectContext: NSManagedObjectContext) -> FeedGroup {
    let newGroup = self.init(context: managedObjectContext)
    
    newGroup.title = title
    
//    do {
//      try managedObjectContext.save()
//    }
//    catch {
//      let nserror = error as NSError
//      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//    }
    
    return newGroup
  }
}
