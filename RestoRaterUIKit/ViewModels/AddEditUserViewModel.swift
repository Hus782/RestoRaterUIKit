//
//  AddEditUserViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import Foundation

enum UserViewScenario {
    case add
    case edit
}

final class AddEditUserViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var isAdmin: Bool = false
    var showingAlert = false
    var errorMessage = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var scenario: UserViewScenario = .add
    var user: User?
    var onAddCompletion: (() -> Void)?
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
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditUserCreateTitle
        case .edit:
            return Lingo.addEditUserEditTitle
        }
    }
    
    init(dataManager: CoreDataManager<User>, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        self.dataManager = dataManager
    }
    
    func initializeWithUser(scenario: UserViewScenario, user: User?) {
        self.scenario = scenario
        self.user = user
        if let user = user {
            self.name = user.name
            self.email = user.email
            self.password = user.password
            self.isAdmin = user.isAdmin
        }
//        Assume that user's data is already valid
        if scenario == .edit {
            isNameValid = true
            isEmailValid = true
            isPasswordValid = true
        }
    }
    
    private func configure(user: User) {
        user.name = name
        user.email = email
        user.password = password
        user.isAdmin = isAdmin
    }
    
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
                self?.showingAlert = true
                self?.errorMessage.value = error.localizedDescription
            }
        }
        isLoading.value = false
    }
    
    func editUser() async -> User? {
        guard let user = user else { return nil}
        user.name = name
        user.email = email
        user.password = password
        user.isAdmin = isAdmin
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
                self?.showingAlert = true
                self?.errorMessage.value = error.localizedDescription
                self?.isLoading.value = false
            }
            return nil
        } 
    }
    
    private func updateFormValidity() {
        isFormValid.value = isEmailValid && isPasswordValid && isNameValid
    }
}
