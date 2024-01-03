//
//  PersistenceController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import CoreData
import UIKit.UIImage

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RestoRaterUIKit")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func populateInitialDataIfNeeded() {
        let isPrePopulated = UserDefaults.standard.bool(forKey: "isPrePopulated")
        
        if !isPrePopulated {
            insertInitialData()
        }
    }
    
    func insertInitialData() {
        // Insert initial data here
        let context = container.viewContext
        
        let restaurant1 = Restaurant(context: context)
        restaurant1.name = "The Gourmet Haven"
        restaurant1.address = "258 Oak Lane, Riverside"
//        Should extract this in a separate class to avoid importing UIKit
        if let image = UIImage(named: "restaurant_image1"),
           let imageData = image.jpegData(compressionQuality: 1.0) {
            restaurant1.image = imageData
        }

        let restaurant2 = Restaurant(context: context)
        restaurant2.name = "Culinary Delights"
        restaurant2.address = "145 Maple Avenue, Sunnyside"
        if let image = UIImage(named: "restaurant_image2"),
           let imageData = image.jpegData(compressionQuality: 1.0) {
            restaurant2.image = imageData
        }

        let restaurant3 = Restaurant(context: context)
        restaurant3.name = "Seaside Bistro"
        restaurant3.address = "932 Ocean View Road, Seaport"
        if let image = UIImage(named: "restaurant_image3"),
           let imageData = image.jpegData(compressionQuality: 1.0) {
            restaurant3.image = imageData
        }
        
        let user1 = User(context: context)
        user1.name = "Test User"
        user1.password = "test"
        user1.email = "test@gmail.com"
        user1.isAdmin = false

        let user2 = User(context: context)
        user2.name = "Admin"
        user2.password = "admin"
        user2.email = "admin@gmail.com"
        user2.isAdmin = true

        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "isPrePopulated")

        } catch {
            print("Failed to save initial data: \(error)")
        }
    }
}

extension PersistenceController {
    static func inMemoryContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "RestoRaterUIKit")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
}
