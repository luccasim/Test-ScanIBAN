//
//  MockCoreData.swift
//  MonCompteFixeTests
//
//  Created by Free on 16/08/2024.
//

import Foundation
import CoreData
@testable import Banane

final class MockCoreData: CoreDataProtocol {

    let service: CoreDataService
    
    init() {
        self.service = .shared
    }
        
    var context: NSManagedObjectContext {
        service.context
    }
    
    func fetch<T>(request: NSFetchRequest<T>) -> [T] where T : NSManagedObject {
        service.fetch(request: request)
    }
    
    func create<T>(entity: T.Type) -> T where T : NSManagedObject {
        service.create(entity: entity)
    }
    
    func first<T>(entity: T.Type, predicate: NSPredicate?) -> T where T : NSManagedObject {
        service.first(entity: entity, predicate: predicate)
    }
    
    func fetch<T>(entity: T.Type, predicate: NSPredicate?) -> [T] where T : NSManagedObject {
        service.fetch(entity: entity, predicate: predicate)
    }
    
    func getContext() -> NSManagedObjectContext {
        service.context
    }
    
    func save() {
        service.save()
    }
    
    func delete<T>(object: T) where T : NSManagedObject {
        service.delete(object: object)
    }
    
    func clear<T: NSManagedObject>(entity: T.Type) {
        service.clear(entity: entity)
    }
}

extension CoreDataProtocol {
    func set(objects: (NSManagedObjectContext) -> Void) {
        if let mock = self as? MockCoreData {
            objects(mock.service.context)
        }
    }
}
