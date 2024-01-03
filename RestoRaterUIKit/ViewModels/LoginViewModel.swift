//
//  LoginViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var alertMessage = Observable<String>("")
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
    var isFormValid = Observable<Bool>(false)
    
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManagerProtocol
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManagerProtocol = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
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
    
    private func updateFormValidity() {
        isFormValid.value = isEmailValid && isPasswordValid
    }
}
