//
//  StarRatingUtility .swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

struct StarRatingUtility {
    static let activeStarColor = Constants.activeStarColor
    static let inactiveStarColor = Constants.inactiveStarColor

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

    static func colorForStar(at index: Int, rating: Double) -> UIColor {
        return index + 1 > Int(rating + 0.5) ? inactiveStarColor : activeStarColor
    }
}
