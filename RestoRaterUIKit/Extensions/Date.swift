//
//  Date.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
