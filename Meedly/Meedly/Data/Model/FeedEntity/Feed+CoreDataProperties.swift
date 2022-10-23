//
//  Feed+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.10.22.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var id: UUID
    @NSManaged public var imageData: Data?
    @NSManaged public var link: URL
    @NSManaged public var title: String?
    @NSManaged public var parentGroup: FeedGroup?

}

extension Feed : Identifiable {

}
