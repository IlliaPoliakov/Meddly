//
//  FeedItemEntity+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 8.11.22.
//
//

import Foundation
import CoreData


extension FeedItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItemEntity> {
        return NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    }

    @NSManaged public var feedItemDescription: String
    @NSManaged public var id: UUID
    @NSManaged public var imageUrl: URL?
    @NSManaged public var isViewed: Bool
    @NSManaged public var link: URL
    @NSManaged public var pubDate: String
    @NSManaged public var title: String
    @NSManaged public var parentGroup: FeedGroupEntity?

}

extension FeedItemEntity : Identifiable {

}
