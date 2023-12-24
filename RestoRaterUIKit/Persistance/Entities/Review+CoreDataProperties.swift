//
//  Review+CoreDataProperties.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var comment: String
    @NSManaged public var visitDate: Date
    @NSManaged public var rating: Int64
    @NSManaged public var restaurant: Restaurant

}

extension Review : Identifiable {

}

extension Review: FetchRequestProvider {}
