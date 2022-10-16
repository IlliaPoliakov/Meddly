//
//  Group+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//
//

import Foundation
import CoreData


extension Group {
  
  @NSManaged public var title: String?
  @NSManaged public var chanels: [FeedChanel]
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
    return NSFetchRequest<Group>(entityName: "Group")
  }
  
  static func create(withTitle title: String,
                     in managedObjectContext: NSManagedObjectContext) {
    let newGroup = self.init(context: managedObjectContext)
    newGroup.title = title
    
    do {
      try managedObjectContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}

// MARK: Generated accessors for chanels
extension Group {
  
  @objc(insertObject:inChanelsAtIndex:)
  @NSManaged public func insertIntoChanels(_ value: FeedChanel, at idx: Int)
  
  @objc(removeObjectFromChanelsAtIndex:)
  @NSManaged public func removeFromChanels(at idx: Int)
  
  @objc(insertChanels:atIndexes:)
  @NSManaged public func insertIntoChanels(_ values: [FeedChanel], at indexes: NSIndexSet)
  
  @objc(removeChanelsAtIndexes:)
  @NSManaged public func removeFromChanels(at indexes: NSIndexSet)
  
  @objc(replaceObjectInChanelsAtIndex:withObject:)
  @NSManaged public func replaceChanels(at idx: Int, with value: FeedChanel)
  
  @objc(replaceChanelsAtIndexes:withChanels:)
  @NSManaged public func replaceChanels(at indexes: NSIndexSet, with values: [FeedChanel])
  
  @objc(addChanelsObject:)
  @NSManaged public func addToChanels(_ value: FeedChanel)
  
  @objc(removeChanelsObject:)
  @NSManaged public func removeFromChanels(_ value: FeedChanel)
  
  @objc(addChanels:)
  @NSManaged public func addToChanels(_ values: NSOrderedSet)
  
  @objc(removeChanels:)
  @NSManaged public func removeFromChanels(_ values: NSOrderedSet)
  
}
