//
//  Segues.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/4/24.
//

import Foundation

enum Segues: String {
    case AddRestaurantSegue
//    case AddRestaurantSegue
    case EditReviewSegue
    case RestaurantDetailsSegue
    case EditRestaurantSegue
    case AddReviewSegue
    case ShowAllReviewsSegue
    case AddUserSegue
    case UserDetailsSegue
    case EditUserSegue
    var val: String {
        return self.rawValue
    }
}
