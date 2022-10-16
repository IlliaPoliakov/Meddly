//
//  Feed+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//
//

import Foundation
import CoreData


extension Feed {
  
  @NSManaged public var title: String?
  @NSManaged public var feedDescription: String?
  @NSManaged public var link: String?
  @NSManaged public var imageUrl: String?
  @NSManaged public var isViewed: Bool
  @NSManaged public var pubDate: String?
  @NSManaged public var chanelList: FeedChanel?
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
    return NSFetchRequest<Feed>(entityName: "Feed")
  }
  
  static func create(withTitle title: String,
                     withDescription feedDescription: String,
                     withLink link: String,
                     withImageUrl imageUrl: String,
                     viewed isViewed: Bool,
                     withPubDate pubDate: String,
                     in managedObjectContext: NSManagedObjectContext) {
    let newFeed = self.init(context: managedObjectContext)
    newFeed.title = title
    newFeed.feedDescription = feedDescription
    newFeed.link = link
    newFeed.imageUrl = imageUrl
    newFeed.isViewed = isViewed
    newFeed.pubDate = pubDate

    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
