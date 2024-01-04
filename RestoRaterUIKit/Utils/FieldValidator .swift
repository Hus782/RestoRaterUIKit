//
//  FieldValidator .swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import Foundation

enum ValidationType {
    case email
    case password
    case none
}

enum ValidationResult: Equatable {
    case success
    case failure(String)

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

struct FieldValidator {
    static func validateEmail(_ email: String) -> ValidationResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) {
            return .success
        } else {
            return .failure(Lingo.invalidEmailFormat)
        }
    }
    
    static func validatePassword(_ password: String) -> ValidationResult {
        let minLength = 8
        if password.count >= minLength {
            return .success
        } else {
            return .failure(Lingo.passwordLengthErrorPrefix + "\(minLength)" + Lingo.passwordLengthErrorSuffix)
        }
    }

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


