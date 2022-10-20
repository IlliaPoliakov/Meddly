//
//  Feed+CoreDataProperties.swift
//  Meedly
//
//  Created by Illia Poliakov on 18.10.22.
//
//

import Foundation
import CoreData


extension Feed {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
    return NSFetchRequest<Feed>(entityName: "Feed")
  }
  
  @NSManaged public var feedDescription: String
  @NSManaged public var id: UUID
  @NSManaged public var image: Data?
  @NSManaged public var isViewed: Bool
  @NSManaged public var link: String
  @NSManaged public var pubDate: String
  @NSManaged public var title: String
  @NSManaged public var group: Group
    
}

extension Feed : Identifiable {
  
}
