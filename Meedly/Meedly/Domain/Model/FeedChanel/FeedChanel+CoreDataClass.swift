//
//  FeedChanel+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.10.22.
//
//

import Foundation
import CoreData

@objc(FeedChanel)
public class FeedChanel: NSManagedObject {
  static func createNew(withTitle title: String? = nil,
                        withImageData imageData: Data?,
                        withLink link: URL,
                        withGroup group: Group,
                        in managedObjectContext: NSManagedObjectContext) {
    let newChanel = self.init(context: managedObjectContext)
    newChanel.title = title
    newChanel.image = imageData
    newChanel.link = link
    newChanel.id = UUID()
    newChanel.group = group
    
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
