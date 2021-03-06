//
//  CoreDataStack.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 06.03.2021.
//

import CoreData

class CoreDataStack {
    private var modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: self.modelName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let container = NSPersistentContainer(name: self.modelName, managedObjectModel: mom)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext () {
        guard self.managedContext.hasChanges else { return }
        
        do {
            try self.managedContext.save()
        } catch {
            let error = error as NSError
            assertionFailure("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    lazy var backgroundManagedContext: NSManagedObjectContext = {
        let bc = self.storeContainer.newBackgroundContext()
        bc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        bc.undoManager = .none
        return bc
    }()
    
    func saveBackgroundContext() {
        if backgroundManagedContext.hasChanges {
            do {
                try backgroundManagedContext.save()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        backgroundManagedContext.reset()
    }
}
