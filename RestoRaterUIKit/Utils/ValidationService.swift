//
//  ValidationService.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import Foundation
struct ValidationService {

    static func validate(text: String, for type: ValidationType) -> ValidationResult {
        switch type {
        case .email:
            return FieldValidator.validateEmail(text)
        case .password:
            return FieldValidator.validatePassword(text)
        }
    }
}
