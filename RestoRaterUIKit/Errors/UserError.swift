//
//  UserError.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import Foundation

enum UserError: Error {
    case addError(String)
    case editError(String)
    case deleteError(String)
    case fetchError(String)
    case userNotFound
    case invalidData
    case unknownError

    var localizedDescription: String {
        switch self {
        case .addError(let message), .editError(let message), .deleteError(let message), .fetchError(let message):
            return message
        case .userNotFound:
            return "User not found."
        case .invalidData:
            return "Invalid user data."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
