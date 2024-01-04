//
//  StarRatingUtility .swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

//  Utility struct for handling star ratings in the application, providing functionality to generate star images and colors based on ratings.
struct StarRatingUtility {
    // Define active and inactive star colors from Constants
    static let activeStarColor = Constants.activeStarColor
    static let inactiveStarColor = Constants.inactiveStarColor
    
    /// Generates an image representing a star's state (filled, half, or empty) based on the rating and index.
    /// - Parameters:
    ///   - rating: The rating value.
    ///   - index: The index of the star.
    /// - Returns: An image representing the star's state.
    static func imageForRating(_ rating: Double, at index: Int) -> UIImage? {
        let doubleIndex = Double(index)
        if doubleIndex + 1 <= rating {
            return Constants.starFilledImage
        } else if doubleIndex + 0.5 <= rating {
            return Constants.starHalfImage
        } else {
            return Constants.starEmptyImage
        }
    }
    
    /// Determines the color of a star based on the current rating.
    /// - Parameters:
    ///   - index: The index of the star.
    ///   - rating: The current rating.
    /// - Returns: A UIColor representing the star's color.
    static func colorForStar(at index: Int, rating: Double) -> UIColor {
        return index + 1 > Int(rating + 0.5) ? inactiveStarColor : activeStarColor
    }
}
