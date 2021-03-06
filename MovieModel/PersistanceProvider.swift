//
//  PersistanceProvider.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 06.03.2021.
//

import CoreData
import UIKit

public typealias Persistanble = NSManagedObject

extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}

public class PersistenceProvider: PitchPersistenceProviderInterface {
    
    private let stack: CoreDataStack
    
    public init() {
        self.stack = CoreDataStack(modelName: "MovieStoreModel")
    }
    
    public func fetchAllRecords<Entity: Persistanble>() -> [Entity] {
        do {
            let request = NSFetchRequest<Entity>(entityName: Entity.entityName)
            let list = try stack.managedContext.fetch(request)
            
            return list
            
        } catch {
            fatalError("objects is not fetched from database with error \(error)")
            
        }
    }
    
    public func fetchRecord<Entity: Persistanble>(with id: String) -> Entity? {
        do {
            let request = NSFetchRequest<Entity>(entityName: Entity.entityName)
            request.predicate = NSPredicate(format: "id == %@", id)
            let list = try stack.managedContext.fetch(request)
            
            return list.first
            
        } catch {
            fatalError("Objects is not got from database")
            
        }
    }
    
    public func saveRecord<Entity: Persistanble>(saveCode: @escaping (Entity) -> Void, completion: @escaping (Bool) -> Void) {
        let object = Entity(context: stack.managedContext)
        saveCode(object)
        stack.saveContext()
        completion(true)
    }
    
    public func removeRecord<Entity: Persistanble>(with id: String, from: Entity.Type) {
        guard let object: Entity = fetchRecord(with: id) else {
            fatalError("object is not found")
        }
        stack.managedContext.delete(object)
        stack.saveContext()
    }
    
    public func removeAllRecord<Entity: Persistanble>(_ entityType: Entity.Type, callback: @escaping () -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try stack.managedContext.execute(deleteRequest)
            stack.saveContext()
            callback()
        } catch {
            fatalError("\(Entity.entityName) removing error")
        }
    }
    
    public func saveImage(image: UIImage) -> String {
        fatalError("saveImage(image:) has not been implemented")
    }
}
