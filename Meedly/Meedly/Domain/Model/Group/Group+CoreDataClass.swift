//
//  Group+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.10.22.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject {
  static func createNew(withTitle title: String,
                        in managedObjectContext: NSManagedObjectContext) -> Group {
    let newGroup = self.init(context: managedObjectContext)
    newGroup.title = title
    newGroup.id = UUID()
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return newGroup
  }
  
}
