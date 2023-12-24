//
//  RegisterViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    var email = Observable<String>("")
    var password = Observable<String>("")
    var name = Observable<String>("")
    var isAdmin = Observable<Bool>(false)
    var showingAlert = Observable<Bool>(false)
    var alertMessage = Observable<String>("")
    var registrationSuccessful = Observable<Bool>(false)
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
            await MainActor.run { [weak self] in
                self?.registrationSuccessful.value = true
                self?.userManager.setIsRegistering(false)
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.alertMessage.value = "\(Lingo.registrationFailed): \(error.localizedDescription)"
                self?.showingAlert.value = true
            }
        }
    }
    
    private func configureUser(newUser: User) {
        newUser.email = email.value
        newUser.password = password.value
        newUser.name = name.value
        newUser.isAdmin = isAdmin.value
    }
    
    func navigateToLogin() {
        userManager.setIsRegistering(false)
    }
}
