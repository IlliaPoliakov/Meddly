//
//  CoreDataStack.swift
//  Meedly
//
//  Created by Illia Poliakov on 18.10.22.
//

import Foundation
import CoreData

class CoreDataStack {
  static let shared = CoreDataStack(modelName: "MeedlyDataModel") // hardcoded, but a kak inache?
  
  private let modelName: String
  
  private init(modelName: String) {
    self.modelName = modelName
  }
  
  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()

  private lazy var storeContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext() {
    guard managedContext.hasChanges
    else {
      return
    }
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      fatalError("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
}
