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

    @NSManaged public var title: String
    @NSManaged public var id: UUID
    @NSManaged public var feeds: [Feed]?
    @NSManaged public var feedChanels: [FeedChanel]?

}

// MARK: Generated accessors for feeds
extension Group {

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: Feed)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: Feed)

    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSSet)

}

// MARK: Generated accessors for feedChanels
extension Group {

    @objc(addFeedChanelsObject:)
    @NSManaged public func addToFeedChanels(_ value: FeedChanel)

    @objc(removeFeedChanelsObject:)
    @NSManaged public func removeFromFeedChanels(_ value: FeedChanel)

    @objc(addFeedChanels:)
    @NSManaged public func addToFeedChanels(_ values: NSSet)

    @objc(removeFeedChanels:)
    @NSManaged public func removeFromFeedChanels(_ values: NSSet)

}

extension Group : Identifiable {

}
