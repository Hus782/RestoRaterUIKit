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
    var userToDelete: User?
    var showingDeleteConfirmation = false
    var isLoading = false
    private let dataManager: CoreDataManager<User>
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>()) {
        self.dataManager = dataManager
//        Task {
//            await fetchUsers()
//        }
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
    
    func promptDelete(user: User) {
        userToDelete = user
        showingDeleteConfirmation = true
    }
    
    func deleteUser(completion: @escaping () -> Void) async {
        guard let user = userToDelete else {
            await MainActor.run { [weak self] in
                self?.showingAlert = true
                self?.alertMessage = "Something went wrong"
            }
            return
        }
        
        do {
            try await dataManager.deleteEntity(entity: user)
            await MainActor.run {
                completion()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
}
