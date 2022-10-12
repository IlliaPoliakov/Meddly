//
//  FeedChanel+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 12.10.22.
//
//

import Foundation
import CoreData


extension FeedChanel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedChanel> {
        return NSFetchRequest<FeedChanel>(entityName: "FeedChanel")
    }

    @NSManaged public var feeds: [Feed]?
    @NSManaged public var group: Group?

}

// MARK: Generated accessors for feeds
extension FeedChanel {

    @objc(insertObject:inFeedsAtIndex:)
    @NSManaged public func insertIntoFeeds(_ value: Feed, at idx: Int)

    @objc(removeObjectFromFeedsAtIndex:)
    @NSManaged public func removeFromFeeds(at idx: Int)

    @objc(insertFeeds:atIndexes:)
    @NSManaged public func insertIntoFeeds(_ values: [Feed], at indexes: NSIndexSet)

    @objc(removeFeedsAtIndexes:)
    @NSManaged public func removeFromFeeds(at indexes: NSIndexSet)

    @objc(replaceObjectInFeedsAtIndex:withObject:)
    @NSManaged public func replaceFeeds(at idx: Int, with value: Feed)

    @objc(replaceFeedsAtIndexes:withFeeds:)
    @NSManaged public func replaceFeeds(at indexes: NSIndexSet, with values: [Feed])

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: Feed)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: Feed)

    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSOrderedSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSOrderedSet)

}

extension FeedChanel : Identifiable {

}