//
//  UsersViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import Foundation

/// ViewModel class for managing user-related functionalities in the application.
final class UsersViewModel {
    // Array to hold the list of users
    var users: [User] = []
    
    // Properties for UI state management
    var showingAlert = false
    var alertMessage = ""
    var isLoading = Observable<Bool>(false)
    
    // Core Data manager for user entity operations
    private let dataManager: CoreDataManager<User>
    
    /// Initializes a new instance of `UsersViewModel`.
    /// - Parameter dataManager: The Core Data manager for handling `User` entity operations.
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>()) {
        self.dataManager = dataManager
    }
    
    /// Fetches the list of users asynchronously and updates the `users` array.
    func fetchUsers() async {
        isLoading.value = true
        do {
            let fetchedUsers = try await dataManager.fetchEntities()
            users = fetchedUsers
            isLoading.value = false
        } catch {
            isLoading.value = false
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }
    
    /// Deletes a specified user asynchronously.
    /// - Parameter userToDelete: The user to be deleted.
    /// - Throws: An error if the deletion fails.
    func deleteUser(_ userToDelete: User?) async throws {
        guard let userToDelete = userToDelete else {
            throw UserError.userNotFound
        }
        try await dataManager.deleteEntity(entity: userToDelete)
    }
}
