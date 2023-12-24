//
//  CoreDataManager.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation
import CoreData

// This is used so that entities can conform to this protocol and be used as types for the generic CoreDataManager
protocol FetchRequestProvider {
    associatedtype FetchRequestResult: NSFetchRequestResult
    static func createFetchRequest() -> NSFetchRequest<FetchRequestResult>
}

final class CoreDataManager<T: NSManagedObject> where T: FetchRequestProvider, T.FetchRequestResult == T {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchEntities(predicate: NSPredicate? = nil) async throws -> [T] {
        let request = T.createFetchRequest()
        request.predicate = predicate
        return try await context.perform {
            try self.context.fetch(request)
        }
    }
    
    func createEntity(configure: (T) -> Void) async throws {
        let newEntity = T(context: context)
        configure(newEntity)
        try await saveContext()
    }
    
    private func saveContext() async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }
    
    func saveEntity(entity: T) async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }
    
    func deleteEntity(entity: T) async throws {
        context.delete(entity)
        try await context.perform {
            try self.context.save()
        }
    }
    
}
