//
//  RegisterViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var isAdmin: Bool = false
    var alertMessage = Observable<String>("")
    
    var registrationSuccessful = Observable<Bool>(false)
    
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
    
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManagerProtocol
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManagerProtocol = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
    func registerUser() async {
        do {
            try await dataManager.createEntity { [weak self] newUser in
                self?.configureUser(newUser: newUser)
            }
            registrationSuccessful.value = true
            userManager.setIsRegistering(false)
            alertMessage.value = Lingo.registrationSuccess
            
        } catch {
            alertMessage.value = "\(Lingo.registrationFailed): \(error.localizedDescription)"
            
        }
    }
    
    private func configureUser(newUser: User) {
        newUser.email = email
        newUser.password = password
        newUser.name = name
        newUser.isAdmin = isAdmin
    }
    
    private func updateFormValidity() {
        isFormValid.value = isEmailValid && isPasswordValid && isNameValid
    }
}
