//
//  Feed+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData

@objc(Feed)
public class Feed: NSManagedObject {
  static func createNew(withTitle title: String? = nil,
                        withImageData imageData: Data?,
                        withLink link: URL,
                        withGroup group: FeedGroup,
                        in managedObjectContext: NSManagedObjectContext) {
    let newFeed = self.init(context: managedObjectContext)
    newFeed.title = title
    newFeed.imageData = imageData
    newFeed.link = link
    newFeed.parentGroup = group
    newFeed.id = UUID()
    
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
