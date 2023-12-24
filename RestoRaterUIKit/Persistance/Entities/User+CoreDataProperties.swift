//
//  User+CoreDataProperties.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var isAdmin: Bool

}

extension User : Identifiable {

}

extension User: FetchRequestProvider {}
