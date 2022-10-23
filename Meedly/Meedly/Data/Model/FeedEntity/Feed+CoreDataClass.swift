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
    let newChanel = self.init(context: managedObjectContext)
    newChanel.title = title
    newChanel.imageData = imageData
    newChanel.link = link
    newChanel.parentGroup = group
    newChanel.id = UUID()
    
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
