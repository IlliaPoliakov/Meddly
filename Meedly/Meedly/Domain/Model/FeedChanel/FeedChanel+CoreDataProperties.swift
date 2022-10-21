//
//  FeedChanel+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 21.10.22.
//
//

import Foundation
import CoreData


extension FeedChanel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedChanel> {
        return NSFetchRequest<FeedChanel>(entityName: "FeedChanel")
    }

    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var link: URL
    @NSManaged public var title: String?
    @NSManaged public var group: Group?

}

extension FeedChanel : Identifiable {

}
