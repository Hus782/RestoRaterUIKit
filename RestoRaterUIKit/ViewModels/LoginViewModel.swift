//
//  LoginViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    var email = Observable<String>("")
    var password = Observable<String>("")
    var loginSuccessful = Observable<Bool>(false)
    var showingAlert = Observable<Bool>(false)
    var alertMessage = Observable<String>("")
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManagerProtocol
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManagerProtocol = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
    func loginUser() async {
        let predicate = NSPredicate(format: "email == %@", email.value)
        
        do {
            let results = try await dataManager.fetchEntities(predicate: predicate)
            if let user = results.first, user.password == password.value {
                await MainActor.run { [weak self] in
                    self?.loginSuccessful.value = true
                    self?.userManager.loginUser(user: user)
                }
                
            } else {
                await MainActor.run { [weak self] in
                    self?.alertMessage.value = Lingo.invalidCredentials
                    self?.showingAlert.value = true
                }
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.alertMessage.value = "\(Lingo.loginFailed): \(error.localizedDescription)"
                self?.showingAlert.value = true
            }
        }
    }
    
    func navigateToRegister() {
        userManager.setIsRegistering(true)
    }
}
