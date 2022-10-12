//
//  Feed+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 12.10.22.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var title: String?
    @NSManaged public var feedDescription: String?
    @NSManaged public var link: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var chanelList: FeedChanel?

}

extension Feed : Identifiable {

}
