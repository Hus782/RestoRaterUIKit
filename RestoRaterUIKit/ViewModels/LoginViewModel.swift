//
//  LoginViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

/// ViewModel class for managing login functionality.
final class LoginViewModel {
    // Properties to hold user input
    var email: String = ""
    var password: String = ""
    
    // Observable properties to communicate with the view
    var alertMessage = Observable<String>("")
    var isFormValid = Observable<Bool>(false)
    
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
    
    // Dependencies
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManagerProtocol
    
    /// Initializes a new `LoginViewModel` instance.
    /// - Parameters:
    ///   - dataManager: The Core Data manager for `User` entity operations.
    ///   - userManager: The `UserManager` instance for managing user session.
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManagerProtocol = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
    /// Attempts to log in the user with the provided credentials.
    /// - Parameter successCompletion: An optional closure to be called on successful login.
    func loginUser(successCompletion: (() -> Void)? = nil) async {
        let predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try await dataManager.fetchEntities(predicate: predicate)
            if let user = results.first, user.password == password {
                await MainActor.run { [weak self] in
                    self?.userManager.loginUser(user: user)
                    successCompletion?()
                }
            } else {
                await MainActor.run { [weak self] in
                    self?.alertMessage.value = Lingo.invalidCredentials
                }
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.alertMessage.value = "\(Lingo.loginFailed): \(error.localizedDescription)"
            }
        }
    }
    
    /// Updates the form validity based on the individual validation flags.
    private func updateFormValidity() {
        isFormValid.value = isEmailValid && isPasswordValid
    }
}
