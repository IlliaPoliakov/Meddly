//
//  Group+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject, Identifiable {
  public var id: UUID = UUID()
}
