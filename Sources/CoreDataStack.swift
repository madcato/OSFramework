//
//  CoreDataStack.swift
//  happic-ios
//
//  Created by Daniel Vela on 29/04/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack: NSObject {

    public init(modelName: String, testing: Bool = false) {
        assert(Thread.current.isMainThread == true) // Create this variable from the main thread
        self.managedObjectModel = NSManagedObjectModel()
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator()
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        super.init()
        self.managedObjectModel = self.createObjectModel(modelName)
        self.persistentStoreCoordinator = self.createPersistentStore(modelName + ".sqlite", testing: testing)
        self.managedObjectContext = self.createObjectContext(self.persistentStoreCoordinator)
    }

    public init(backgroundWithMaster database: CoreDataStack) {
        assert(Thread.current.isMainThread == false) // Create this variable from a background thread
        self.managedObjectModel = database.managedObjectModel
        self.persistentStoreCoordinator = database.persistentStoreCoordinator
        self.managedObjectContext = database.createObjectContextForPrivateThread()
    }

    private func createObjectModel(_ modelName: String) -> NSManagedObjectModel {
        // The managed object model for the application. This property is not optional.
        // It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }

    private func createObjectContext(_ persistentStoreCoordinator: NSPersistentStoreCoordinator) ->
        NSManagedObjectContext {
        // Returns the managed object context for the application (which is already
        // bound to the persistent store coordinator for the application.) This property
        // is optional since there are legitimate error conditions that could cause
        // the creation of the context to fail.
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }

    private func createPersistentStore(_ fileName: String, testing: Bool) -> NSPersistentStoreCoordinator {
        if testing == true {
            return createInMemoryPersistentStore()
        } else {
            return createSQLitePersistentStore(fileName)
        }
    }

    private func createSQLitePersistentStore(_ fileName: String) -> NSPersistentStoreCoordinator {
        // The persistent store coordinator for the application. This implementation
        // creates and returns a coordinator, having added the store for the application
        // to it. This property is optional since there are legitimate error conditions
        // that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(fileName)
        let failureReason = "There was an error creating or loading the application's saved data."
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: options)
        } catch let error as NSError {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?

            dict[NSUnderlyingErrorKey] = error
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although
            // it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        } catch {
            // dummy
        }
        return coordinator
    }

    private func createInMemoryPersistentStore() -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let failureReason = "There was an error creating or loading the application's saved data."
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        // Unit testing: store in memory
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                               configurationName: nil,
                                               at: nil,
                                               options: options)
        } catch let error as NSError {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?

            dict[NSUnderlyingErrorKey] = error
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although
            // it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }

    private func createObjectContextForPrivateThread() -> NSManagedObjectContext {
        let newManagedObjectContext = NSManagedObjectContext(concurrencyType:
            NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        newManagedObjectContext.performAndWait {
            newManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        }
        newManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return newManagedObjectContext
    }

    // MARK: - Core Data Stack

    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. 
        // This code uses a directory named "org.veladan.happic_ios" in the application's 
        // documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    private var managedObjectModel: NSManagedObjectModel

    private var persistentStoreCoordinator: NSPersistentStoreCoordinator

    internal var managedObjectContext: NSManagedObjectContext

    // MARK: - Core Data Saving support

    public func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. 
                // You should not use this function in a shipping application, although it 
                // may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
