//
//  UserManager.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

struct UserData {
    let name: String
    let email: String
    let isAdmin: Bool
}

// Expose the important methods for testing and mocking
protocol UserManagerProtocol {
    func loginUser(user: User)
    func isCurrentUser(user: User) -> Bool
    func logoutUser()
    func setIsRegistering(_ value: Bool)
}

final class UserManager: ObservableObject, UserManagerProtocol {
    @Published var currentUser: UserData?
    @Published var isLoggedIn: Bool = false
    @Published private(set) var isRegistering: Bool = true
    
    // Keys for UserDefaults
    private let isLoggedInKey = "isLoggedIn"
    private let isAdminKey = "isAdminKey"
    private let userEmailKey = "userEmail"
    private let userNameKey = "userName"
    
    // Singleton instance for global access
    static let shared = UserManager()
    
    // Private constructor for singleton
    private init() {
        loadUserFromDefaults()
    }
    
    func isCurrentUser(user: User) -> Bool {
        if let currentName = currentUser?.name, let currentEmail = currentUser?.email, currentName == user.name, currentEmail == user.email {
            return true
        } else {
            return false
        }
    }

    func loginUser(user: User) {
        currentUser = UserData(name: user.name, email: user.email, isAdmin: user.isAdmin)
        isLoggedIn = true
        saveUserToDefaults()
    }
    
    func logoutUser() {
        self.currentUser = nil
        self.isLoggedIn = false
        clearUserDefaults()
    }
    
    func setIsRegistering(_ value: Bool) {
        isRegistering = value
    }
    
    private func saveUserToDefaults() {
        UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
        UserDefaults.standard.set(currentUser?.email, forKey: userEmailKey)
        UserDefaults.standard.set(currentUser?.name, forKey: userNameKey)
        UserDefaults.standard.set(currentUser?.isAdmin, forKey: isAdminKey)
    }
    
    private func loadUserFromDefaults() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        if isLoggedIn {
            let email = UserDefaults.standard.string(forKey: userEmailKey) ?? ""
            let name = UserDefaults.standard.string(forKey: userNameKey) ?? ""
            let isAdmin = UserDefaults.standard.bool(forKey: isAdminKey)

            // Create a user object with the stored values
            let user = UserData(name: name, email: email, isAdmin: isAdmin)
            self.currentUser = user
            self.isLoggedIn = true
        }
    }
    
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: isLoggedInKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: isAdminKey)
    }
    
}
