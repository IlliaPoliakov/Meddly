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
                        viewed isViewed: Bool,
                        withPubDate pubDate: String,
                        in managedObjectContext: NSManagedObjectContext,
                        withhGroup group: Group) {
    let newFeed = self.init(context: managedObjectContext)
    newFeed.title = title
    newFeed.feedDescription = feedDescription
    newFeed.link = link
    newFeed.image = imageData
    newFeed.isViewed = isViewed
    newFeed.pubDate = pubDate
    newFeed.id = UUID()
    newFeed.group = group
    
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
