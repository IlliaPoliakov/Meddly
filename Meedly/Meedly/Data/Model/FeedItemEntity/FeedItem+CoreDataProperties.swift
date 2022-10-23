//
//  FeedItem+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData


extension FeedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItem> {
        return NSFetchRequest<FeedItem>(entityName: "FeedItem")
    }

    @NSManaged public var feedItemDescription: String
    @NSManaged public var imageData: Data?
    @NSManaged public var pubDate: String
    @NSManaged public var title: String
    @NSManaged public var link: URL
    @NSManaged public var parentGroup: FeedGroup

}

extension FeedItem : Identifiable {

}
