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
    @NSManaged public var image: Data
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
    //    These methods are not very efficient, for large number of reviews it is better to save each in core data
    var averageRating: Double {
        guard let reviews = reviews?.allObjects as? [Review], !reviews.isEmpty else { return 0.0 }
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(reviews.count)
    }
    
    var highestRatedReview: Review? {
        return (reviews?.allObjects as? [Review])?.max(by: { $0.rating < $1.rating })
    }
    
    var lowestRatedReview: Review? {
        return (reviews?.allObjects as? [Review])?.min(by: { $0.rating < $1.rating })
    }
    
    var latestReview: Review? {
        return (reviews?.allObjects as? [Review])?.max(by: { $0.visitDate < $1.visitDate })
    }
    
    var hasReviews: Bool {
        return (reviews?.count ?? 0) > 0
    }
}

extension Restaurant: FetchRequestProvider {}
