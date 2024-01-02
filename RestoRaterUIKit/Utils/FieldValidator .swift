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
            return .failure("Invalid email format")
        }
    }

    static func validatePassword(_ password: String) -> ValidationResult {
        let minLength = 8
        if password.count >= minLength {
            return .success
        } else {
            return .failure("Password must be at least \(minLength) characters")
        }
    }

    static func checkCharacterLimit(_ text: String, limit: Int) -> ValidationResult {
        if text.count <= limit {
            return .success
        } else {
            return .failure("Text exceeds limit of \(limit) characters")
        }
    }

}

