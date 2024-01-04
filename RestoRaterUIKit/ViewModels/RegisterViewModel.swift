//
//  RegisterViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

/// ViewModel class for managing registration functionality.
final class RegisterViewModel {
    // Properties to hold user input
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var isAdmin: Bool = false
    
    // Observable properties to communicate with the view
    var errorMessage = Observable<String>("")
    var alertMessage = Observable<String>("")
    var registrationSuccessful = Observable<Bool>(false)
    
    // Validation flags
    var isEmailValid: Bool = false  {
        didSet {
            updateFormValidity()
        }
    }
    var isPasswordValid: Bool = false {
        didSet {
            updateFormValidity()
        }
    }
    var isNameValid: Bool = false {
        didSet {
            updateFormValidity()
        }
    }
    var isFormValid = Observable<Bool>(false)
    
    // Dependencies
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManagerProtocol
    
    /// Initializes a new `RegisterViewModel` instance.
    /// - Parameters:
    ///   - dataManager: The Core Data manager for `User` entity operations.
    ///   - userManager: The `UserManager` instance for managing user session.
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManagerProtocol = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
    /// Attempts to register a new user with the provided details.
    func registerUser() async {
        let predicate = NSPredicate(format: "email == %@", email)
        do {
            let results = try await dataManager.fetchEntities(predicate: predicate)
            if !results.isEmpty {
                errorMessage.value = Lingo.emailTakenMessage
                return
            }
        } catch {
            errorMessage.value = "\(Lingo.registrationFailed): \(error.localizedDescription)"
            return
        }
        
        do {
            try await dataManager.createEntity { [weak self] newUser in
                self?.configureUser(newUser: newUser)
            }
            registrationSuccessful.value = true
            userManager.setIsRegistering(false)
            alertMessage.value = Lingo.registrationSuccess
        } catch {
            errorMessage.value = "\(Lingo.registrationFailed): \(error.localizedDescription)"
        }
    }
    
    /// Configures a new `User` entity with the input data.
    private func configureUser(newUser: User) {
        newUser.email = email
        newUser.password = password
        newUser.name = name
        newUser.isAdmin = isAdmin
    }
    
    /// Updates the overall form validity based on individual field validations.
    private func updateFormValidity() {
        isFormValid.value = isEmailValid && isPasswordValid && isNameValid
    }
}
