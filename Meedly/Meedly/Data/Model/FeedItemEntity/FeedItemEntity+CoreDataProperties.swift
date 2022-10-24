//
//  FeedItem+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData


extension FeedItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItemEntity> {
        return NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    }

    @NSManaged public var feedItemDescription: String
    @NSManaged public var imageData: Data?
    @NSManaged public var pubDate: String
    @NSManaged public var title: String
    @NSManaged public var link: URL
    @NSManaged public var parentGroup: FeedGroupEntity
    @NSManaged public var id: UUID

}

extension FeedItemEntity : Identifiable {

}
