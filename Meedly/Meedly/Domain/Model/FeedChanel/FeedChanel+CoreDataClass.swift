//
//  FeedChanel+CoreDataClass.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//
//

import Foundation
import CoreData

@objc(FeedChanel)
public class FeedChanel: NSManagedObject, Identifiable {
  public var id: UUID = UUID()
}
