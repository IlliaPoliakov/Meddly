//
//  FeedGroup+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData


extension FeedGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedGroup> {
        return NSFetchRequest<FeedGroup>(entityName: "FeedGroup")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var feeds: NSOrderedSet?
    @NSManaged public var items: NSOrderedSet?

}

// MARK: Generated accessors for feeds
extension FeedGroup {

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

// MARK: Generated accessors for items
extension FeedGroup {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: FeedItem, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [FeedItem], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: FeedItem)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [FeedItem])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: FeedItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: FeedItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

extension FeedGroup : Identifiable {

}
