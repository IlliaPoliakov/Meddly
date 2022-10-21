//
//  Group+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.10.22.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var chanels: [FeedChanel]?
    @NSManaged public var feeds: [Feed]?

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

// MARK: Generated accessors for feeds
extension Group {

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

extension Group : Identifiable {

}
