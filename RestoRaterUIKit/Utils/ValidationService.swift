//
//  ValidationService.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import Foundation

/// A struct that offers validation services for various types of input fields.
struct ValidationService {
    
    /// Validates a given text based on a specified validation type.
    /// - Parameters:
    ///   - text: The text to be validated.
    ///   - type: The type of validation to be applied (email, password, etc.).
    /// - Returns: A `ValidationResult` indicating success or failure (with message).
    static func validate(text: String, for type: ValidationType) -> ValidationResult {
        switch type {
        case .email:
            return FieldValidator.validateEmail(text)
        case .password:
            return FieldValidator.validatePassword(text)
        case .none:
            return FieldValidator.checkCharacterLimits(text)
        }
    }
}
