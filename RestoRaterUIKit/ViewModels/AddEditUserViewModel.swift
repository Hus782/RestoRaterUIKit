//
//  AddEditUserViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import Foundation

/// Enumeration to represent the different scenarios for the user view.
enum UserViewScenario {
    case add
    case edit
}

/// ViewModel class for adding or editing users.
final class AddEditUserViewModel {
    // User input properties
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var isAdmin: Bool = false
    
    // Observable properties for UI state management
    var errorMessage = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var scenario: UserViewScenario = .add
    var user: User?
    var onAddCompletion: (() -> Void)?
    
    // Validation flags
    var isEmailValid: Bool = false  {
        didSet { updateFormValidity() }
    }
    var isPasswordValid: Bool = false {
        didSet { updateFormValidity() }
    }
    var isNameValid: Bool = false {
        didSet { updateFormValidity() }
    }
    var isFormValid = Observable<Bool>(false)
    
    // Core Data manager for user entity operations
    private let dataManager: CoreDataManager<User>
    
    // Title based on the current scenario
    var title: String {
        switch scenario {
        case .add: return Lingo.addEditUserCreateTitle
        case .edit: return Lingo.addEditUserEditTitle
        }
    }
    
    /// Initializes a new `AddEditUserViewModel` instance.
    init(dataManager: CoreDataManager<User>, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        self.dataManager = dataManager
    }
    
    /// Initializes the ViewModel with a specific user and scenario.
    func initializeWithUser(scenario: UserViewScenario, user: User?) {
        self.scenario = scenario
        self.user = user
        if let user = user {
            self.name = user.name
            self.email = user.email
            self.password = user.password
            self.isAdmin = user.isAdmin
        }
        // Assume that existing user data is valid
        if scenario == .edit {
            isNameValid = true
            isEmailValid = true
            isPasswordValid = true
        }
    }
    
    /// Configures a `User` entity with the current input data.
    private func configure(user: User) {
        user.name = name
        user.email = email
        user.password = password
        user.isAdmin = isAdmin
    }
    
    /// Adds a new user asynchronously.
    func addUser() async {
        isLoading.value = true
        do {
            try await dataManager.createEntity { [weak self] (user: User) in
                self?.configure(user: user)
            }
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.errorMessage.value = error.localizedDescription
            }
        }
        isLoading.value = false
    }
    
    /// Edits an existing user asynchronously.
    func editUser() async -> User? {
        guard let user = user else { return nil }
        configure(user: user)
        isLoading.value = true
        do {
            try await dataManager.saveEntity(entity: user)
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
                self?.isLoading.value = false
            }
            return user
        } catch {
            await MainActor.run { [weak self] in
                self?.errorMessage.value = error.localizedDescription
                self?.isLoading.value = false
            }
            return nil
        }
    }
    
    /// Updates the overall form validity based on individual field validations.
    private func updateFormValidity() {
        isFormValid.value = isEmailValid && isPasswordValid && isNameValid
    }
}
