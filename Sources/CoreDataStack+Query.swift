//
//  CoreDataStack+Query.swift
//  OSFramework
//
//  Created by Daniel Vela on 22/01/2018.
//  Copyright © 2018 Daniel Vela. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStack {
    // MARK - Core Data quering

    public func getObjectFrom(_ entityName: String, _ wherePredicate: Where) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
        assert(entity != nil)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        fetchRequest.predicate = wherePredicate.predicate

        do {
            let fetchedObjects = try self.managedObjectContext.fetch(fetchRequest)
            assert(fetchedObjects.count < 2) // Zero or only one are correct

            if fetchedObjects.count == 0 {
                return nil
            }

            return fetchedObjects[0]
        } catch let error as NSError {
            NSLog("Error getObjectFrom %@", error.localizedDescription)
            return nil
        }
    }

    public func getResultsFrom(_ entityName: String, _ sortBy: SortBy? = nil, _ wherePredicate: Where? = nil) -> [Any] {
        let fetchRequest = NSFetchRequest<NSManagedObject>()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
        assert(entity != nil)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        if let sortBy = sortBy {
            fetchRequest.sortDescriptors = sortBy.sortDescriptors
        }
        if let wherePredicate = wherePredicate {
            fetchRequest.predicate = wherePredicate.predicate
        }

        do {
            let fetchedObjects = try self.managedObjectContext.fetch(fetchRequest)

            return fetchedObjects
        } catch let error as NSError {
            NSLog("Error getResultsFrom %@", error.localizedDescription)
            return []
        }
    }

    public func createFetchedResultsController(_ entityName: String,
                                               _ sortBy: SortBy? = nil,
                                               _ wherePredicate: Where? = nil,
                                               sectionNameKeyPath: String?) ->
        NSFetchedResultsController<NSManagedObject>? {
            let fetchRequest = NSFetchRequest<NSManagedObject>()
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
            assert(entity != nil)
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            if let sortBy = sortBy {
                fetchRequest.sortDescriptors = sortBy.sortDescriptors
            }
            if let wherePredicate = wherePredicate {
                fetchRequest.predicate = wherePredicate.predicate
            }
            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                       managedObjectContext: self.managedObjectContext,
                                                                       sectionNameKeyPath: sectionNameKeyPath,
                                                                       cacheName: nil)
            return aFetchedResultsController
    }

    public func fetch(_ fetchedResultController: NSFetchedResultsController<NSManagedObject>) {
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            NSLog("Error performFetch %@", error.localizedDescription)
        }
    }

    public func createObject(_ entityName: String) -> NSManagedObject? {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                                into: self.managedObjectContext)
        return managedObject
    }

    public func deleteObjects(_ entityName: String, wherePredicate: Where? = nil) {
        let fetchRequest = NSFetchRequest<NSManagedObject>()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
        assert(entity != nil)
        fetchRequest.entity = entity
        if let wherePredicate = wherePredicate {
            fetchRequest.predicate = wherePredicate.predicate
        }

        do {
            let fetchedObjects = try self.managedObjectContext.fetch(fetchRequest)

            for object in fetchedObjects {
                self.managedObjectContext.delete(object)
            }
        } catch let error as NSError {
            NSLog("Error deleteObjects %@", error.localizedDescription)
        }
    }

    public func delete(_ object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }

    public func deleteAll(entities entityName: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        do {
            let fetchedObjects = try self.managedObjectContext.fetch(fetchRequest) as [NSManagedObject]
            for object in fetchedObjects {
                self.managedObjectContext.delete(object)
            }
            try self.managedObjectContext.save()
        } catch let error as NSError {
            NSLog("Error deleteAll %@", error.localizedDescription)
        }

    }

    public func count(_ entityName: String) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.includesPropertyValues = false
        do {
            let count = try self.managedObjectContext.count(for: request)
            if count == NSNotFound {
                NSLog("Unresolved error in count")
                return NSNotFound
            }
            return  count
        } catch let error as NSError {
            NSLog("Error deleteAll %@", error.localizedDescription)
        }
        return NSNotFound
    }
}
