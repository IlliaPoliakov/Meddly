//
//  Feed+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.10.22.
//
//

import Foundation
import CoreData

@objc(Feed)
public class Feed: NSManagedObject {
  static func createNew(withTitle title: String,
                        withDescription feedDescription: String,
                        withLink link: URL,
                        withImageData imageData: Data?,
                        withPubDate pubDate: String,
                        in managedObjectContext: NSManagedObjectContext,
                        withhGroup group: Group) {
    let newFeed = self.init(context: managedObjectContext)
    newFeed.title = title
    newFeed.feedDescription = feedDescription
    newFeed.link = link
    newFeed.image = imageData
    newFeed.pubDate = pubDate
    newFeed.id = UUID()
    newFeed.parentGroup = group
    
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
