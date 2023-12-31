//
//  UsersViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import Foundation

final class UsersViewModel {
    var users: [User] = []
    var showingAlert = false
    var alertMessage = ""
    var isLoading = false
    private let dataManager: CoreDataManager<User>
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>()) {
        self.dataManager = dataManager
    }
    
    func fetchUsers() async {
        do {
            await MainActor.run { [weak self] in
                self?.isLoading = true
            }
            
            let fetchedUsers = try await dataManager.fetchEntities()
            await MainActor.run { [weak self] in
                self?.users = fetchedUsers
                self?.isLoading = false
            }
            
        } catch {
            await MainActor.run { [weak self] in
                self?.isLoading = false
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func deleteUser(_ userToDelete: User?) async -> Result<Void, Error> {
        guard let userToDelete = userToDelete else {
//            Create specific errors here
            let error = NSError(domain: "UserDeletionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            return .failure(error)
        }
        do {
            try await dataManager.deleteEntity(entity: userToDelete)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
}
