//
//  Restaurant+CoreDataProperties.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var address: String
    @NSManaged public var name: String
    @NSManaged public var image: Data?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for reviews
extension Restaurant {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}

extension Restaurant : Identifiable {

}

extension Restaurant: FetchRequestProvider {}
