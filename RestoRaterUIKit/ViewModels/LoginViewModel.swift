//
//  LoginViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var loginSuccessful = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManagerProtocol
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManagerProtocol = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
    func loginUser() async {
        let predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try await dataManager.fetchEntities(predicate: predicate)
            if let user = results.first, user.password == password { // Consider hashing the password
                await MainActor.run { [weak self] in
                    self?.loginSuccessful = true
                    self?.userManager.loginUser(user: user)
                }
                
            } else {
                await MainActor.run { [weak self] in
                    self?.alertMessage = Lingo.invalidCredentials
                    self?.showingAlert = true
                }
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.alertMessage = "\(Lingo.loginFailed): \(error.localizedDescription)"
                self?.showingAlert = true
            }
        }
    }
    
    func navigateToRegister() {
        userManager.setIsRegistering(true)
    }
}
