//
//  FeedGroupEntity+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 8.11.22.
//
//

import Foundation
import CoreData


extension FeedGroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedGroupEntity> {
        return NSFetchRequest<FeedGroupEntity>(entityName: "FeedGroupEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var feeds: [FeedEntity]?
    @NSManaged public var items: [FeedItemEntity]?

}

// MARK: Generated accessors for feeds
extension FeedGroupEntity {

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: FeedEntity)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: FeedEntity)

    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSSet)

}

// MARK: Generated accessors for items
extension FeedGroupEntity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: FeedItemEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: FeedItemEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension FeedGroupEntity : Identifiable {

}
