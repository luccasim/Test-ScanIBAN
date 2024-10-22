//
//  CoreDataProtocol.swift
//  Banane
//
//  Created by Luc on 22/10/2024.
//

import Foundation
import CoreData

protocol CoreDataProtocol: Sendable {
    func create<T: NSManagedObject>(entity: T.Type) -> T
    func fetch<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate?) -> [T]
    func delete<T: NSManagedObject>(object: T)
    func save()
}

extension CoreDataService: CoreDataProtocol {
    
}
