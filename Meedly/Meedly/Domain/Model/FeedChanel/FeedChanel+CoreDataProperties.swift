//
//  FeedChanel+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 17.10.22.
//
//

import Foundation
import CoreData


extension FeedChanel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedChanel> {
    return NSFetchRequest<FeedChanel>(entityName: "FeedChanel")
  }
  
  @NSManaged public var imageUrl: String?
  @NSManaged public var link: String?
  @NSManaged public var title: String?
  @NSManaged public var id: UUID?
  @NSManaged public var group: Group?
  
  static func createNew(withTitle title: String,
                        withImageurl imageUrl: String?,
                        withLink link: String,
                        in managedObjectContext: NSManagedObjectContext) {
    let newChanel = self.init(context: managedObjectContext)
    newChanel.title = title
    newChanel.imageUrl = imageUrl
    newChanel.link = link
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
  
  
}

extension FeedChanel : Identifiable {
  
}
