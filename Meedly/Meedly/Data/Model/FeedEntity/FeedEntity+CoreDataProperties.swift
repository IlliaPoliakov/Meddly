//
//  FeedEntity+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 28.10.22.
//
//

import Foundation
import CoreData


extension FeedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedEntity> {
        return NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var imageData: Data?
    @NSManaged public var link: URL
    @NSManaged public var title: String?
    @NSManaged public var parentGroup: FeedGroupEntity?

}

extension FeedEntity : Identifiable {

}