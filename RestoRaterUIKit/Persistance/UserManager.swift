//
//  UserManager.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

/// Struct representing the user's data.
struct UserData {
    let name: String
    let email: String
    let isAdmin: Bool
}

/// Protocol to define the key functionalities of the UserManager, useful for testing and mocking.
protocol UserManagerProtocol {
    func loginUser(user: User)
    func isCurrentUser(user: User) -> Bool
    func logoutUser()
    func setIsRegistering(_ value: Bool)
}

/// Singleton class responsible for managing user authentication, session state, and user data.
final class UserManager: ObservableObject, UserManagerProtocol {
    @Published var currentUser: UserData?
    @Published var isLoggedIn: Bool = false
    @Published private(set) var isRegistering: Bool = true
    
    // Keys used for storing data in UserDefaults
    private let isLoggedInKey = "isLoggedIn"
    private let isAdminKey = "isAdminKey"
    private let userEmailKey = "userEmail"
    private let userNameKey = "userName"
    
    // Singleton instance for global access
    static let shared = UserManager()
    
    // Private constructor to enforce singleton usage
    private init() {
        loadUserFromDefaults()
    }
    
    /// Checks if the specified user is the current user.
    func isCurrentUser(user: User) -> Bool {
        return currentUser?.name == user.name && currentUser?.email == user.email
    }
    
    /// Logs in the user and persists the user data.
    func loginUser(user: User) {
        currentUser = UserData(name: user.name, email: user.email, isAdmin: user.isAdmin)
        isLoggedIn = true
        saveUserToDefaults()
    }
    
    /// Logs out the current user and clears persisted data.
    func logoutUser() {
        currentUser = nil
        isLoggedIn = false
        clearUserDefaults()
    }
    
    /// Sets the registration status for the current session.
    func setIsRegistering(_ value: Bool) {
        isRegistering = value
    }
    
    // Persists user data to UserDefaults
    private func saveUserToDefaults() {
        UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
        UserDefaults.standard.set(currentUser?.email, forKey: userEmailKey)
        UserDefaults.standard.set(currentUser?.name, forKey: userNameKey)
        UserDefaults.standard.set(currentUser?.isAdmin, forKey: isAdminKey)
    }
    
    // Loads user data from UserDefaults
    private func loadUserFromDefaults() {
        isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        if isLoggedIn {
            let email = UserDefaults.standard.string(forKey: userEmailKey) ?? ""
            let name = UserDefaults.standard.string(forKey: userNameKey) ?? ""
            let isAdmin = UserDefaults.standard.bool(forKey: isAdminKey)
            currentUser = UserData(name: name, email: email, isAdmin: isAdmin)
        }
    }
    
    // Clears user data from UserDefaults
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: isLoggedInKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: isAdminKey)
    }
}
