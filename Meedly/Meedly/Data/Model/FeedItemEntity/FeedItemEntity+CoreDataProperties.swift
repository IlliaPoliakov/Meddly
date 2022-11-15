//
//  FeedItemEntity+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//
//

import Foundation
import CoreData


extension FeedItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItemEntity> {
        return NSFetchRequest<FeedItemEntity>(entityName: "FeedItemEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var link: URL
    @NSManaged public var imageUrl: URL?
    @NSManaged public var itemDescription: String
    @NSManaged public var pubDate: Date
    @NSManaged public var isViewed: Bool
    @NSManaged public var isLiked: Bool
    @NSManaged public var parentGroup: String

}

extension FeedItemEntity : Identifiable {

}
