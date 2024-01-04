//
//  FieldValidator .swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import Foundation

/// Enumeration defining the types of validations that can be performed.
enum ValidationType {
    case email
    case password
    case none
}

/// Enumeration representing the result of a validation operation.
enum ValidationResult: Equatable {
    case success
    case failure(String)
    
    /// Equatable conformance to compare validation results.
    static func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.failure(let a), .failure(let b)):
            return a == b
        default:
            return false
        }
    }
}

//  Provides utility functions to validate different types of input fields such as email and password.
struct FieldValidator {
    
    /// Validates an email address for proper formatting.
    /// - Parameter email: The email address to be validated.
    /// - Returns: A `ValidationResult` indicating success or failure (with message).
    static func validateEmail(_ email: String) -> ValidationResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) {
            return .success
        } else {
            return .failure(Lingo.invalidEmailFormat)
        }
    }
    
    /// Validates a password to ensure it meets a minimum length requirement.
    /// - Parameter password: The password string to be validated.
    /// - Returns: A `ValidationResult` indicating success or failure (with message).
    static func validatePassword(_ password: String) -> ValidationResult {
        let minLength = 8
        if password.count >= minLength {
            return .success
        } else {
            return .failure(Lingo.passwordLengthErrorPrefix + "\(minLength)" + Lingo.passwordLengthErrorSuffix)
        }
    }
    
    /// Checks if the character count of a text is within specified limits.
    /// - Parameters:
    ///   - text: The text to be checked.
    ///   - min: The minimum character count required.
    ///   - max: The maximum character count allowed.
    /// - Returns: A `ValidationResult` indicating success or failure (with message).
    static func checkCharacterLimits(_ text: String, min: Int = 1, max: Int = 50) -> ValidationResult {
        if text.isEmpty {
            return .failure(Lingo.fieldCannotBeEmpty)
        } else if text.count < min {
            return .failure(Lingo.textMinimumLengthErrorPrefix + "\(min)" + Lingo.textMinimumLengthErrorSuffix)
        } else if text.count > max {
            return .failure(Lingo.textMaximumLengthErrorPrefix + "\(max)" + Lingo.textMaximumLengthErrorSuffix)
        } else {
            return .success
        }
    }
}

