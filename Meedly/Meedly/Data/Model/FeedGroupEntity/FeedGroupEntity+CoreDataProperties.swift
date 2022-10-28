//
//  FeedGroupEntity+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//
//

import Foundation
import CoreData


extension FeedGroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedGroupEntity> {
        return NSFetchRequest<FeedGroupEntity>(entityName: "FeedGroupEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var id: UUID
    @NSManaged public var feeds: [FeedEntity]?
    @NSManaged public var items: [FeedItemEntity]?

}

// MARK: Generated accessors for feeds
extension FeedGroupEntity {

    @objc(insertObject:inFeedsAtIndex:)
    @NSManaged public func insertIntoFeeds(_ value: FeedEntity, at idx: Int)

    @objc(removeObjectFromFeedsAtIndex:)
    @NSManaged public func removeFromFeeds(at idx: Int)

    @objc(insertFeeds:atIndexes:)
    @NSManaged public func insertIntoFeeds(_ values: [FeedEntity], at indexes: NSIndexSet)

    @objc(removeFeedsAtIndexes:)
    @NSManaged public func removeFromFeeds(at indexes: NSIndexSet)

    @objc(replaceObjectInFeedsAtIndex:withObject:)
    @NSManaged public func replaceFeeds(at idx: Int, with value: FeedEntity)

    @objc(replaceFeedsAtIndexes:withFeeds:)
    @NSManaged public func replaceFeeds(at indexes: NSIndexSet, with values: [FeedEntity])

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: FeedEntity)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: FeedEntity)

    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSOrderedSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSOrderedSet)

}

// MARK: Generated accessors for items
extension FeedGroupEntity {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: FeedItemEntity, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [FeedItemEntity], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: FeedItemEntity)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [FeedItemEntity])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: FeedItemEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: FeedItemEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

extension FeedGroupEntity : Identifiable {

}
