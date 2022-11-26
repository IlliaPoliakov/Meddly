//
//  CoreDataStack.swift
//  Meedly
//
//  Created by Illia Poliakov on 18.10.22.
//

import CoreData
import UIKit

final class CoreDataManager {
  
  init(modelName: String) {
    self.modelName = modelName
    
    setupNotificationHandling()
  }
  
  
  // MARK: - Properties
  
  private let modelName: String
  
  
  // MARK: - Core Data Stack
  
  private(set) lazy var managedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    managedObjectContext.parent = self.privateManagedObjectContext
    
    return managedObjectContext
  }()
  
  private lazy var privateManagedObjectContext: NSManagedObjectContext = {
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    return managedObjectContext
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
      fatalError("Unable to Find Data Model")
    }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable to Load Data Model")
    }
    
    return managedObjectModel
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
    let fileManager = FileManager.default
    let storeName = "\(self.modelName).sqlite"
    
    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
    
    do {
      let options = [ NSInferMappingModelAutomaticallyOption : true,
                NSMigratePersistentStoresAutomaticallyOption : true]
      
      try persistentStoreCoordinator.addPersistentStore(
        ofType: NSSQLiteStoreType,
        configurationName: nil,
        at: persistentStoreURL,
        options: options)
    } catch {
      fatalError("Unable to Load Persistent Store")
    }
    
    return persistentStoreCoordinator
  }()
  
  
  // -MARK: - Supp Funcs -
  
  private func setupNotificationHandling() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(CoreDataManager.saveChanges(_:)), name: UIApplication.willTerminateNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(CoreDataManager.saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
  }
  
  @objc private func saveChanges(_ notification: NSNotification) {
    managedObjectContext.perform {
      do {
        if self.managedObjectContext.hasChanges {
          try self.managedObjectContext.save()
        }
      } catch {
        let saveError = error as NSError
        print("Unable to Save Changes of Managed Object Context")
        print("\(saveError), \(saveError.localizedDescription)")
      }
      
      self.privateManagedObjectContext.perform {
        do {
          if self.privateManagedObjectContext.hasChanges {
            try self.privateManagedObjectContext.save()
          }
        } catch {
          let saveError = error as NSError
          print("Unable to Save Changes of Private Managed Object Context")
          print("\(saveError), \(saveError.localizedDescription)")
        }
      }
      
    }
  }
}

