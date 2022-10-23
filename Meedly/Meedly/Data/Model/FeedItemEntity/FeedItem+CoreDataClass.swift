//
//  FeedItem+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData

@objc(FeedItem)
public class FeedItem: NSManagedObject {
  
  static func createNew(withTitle title: String,
                        withDescription feedDescription: String,
                        withLink link: URL,
                        withImageData imageData: Data?,
                        withPubDate pubDate: String,
                        in managedObjectContext: NSManagedObjectContext,
                        withhGroup group: FeedGroup) {
    let newFeed = self.init(context: managedObjectContext)
    newFeed.title = title
    newFeed.feedItemDescription = feedDescription
    newFeed.link = link
    newFeed.imageData = imageData
    newFeed.pubDate = pubDate
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
