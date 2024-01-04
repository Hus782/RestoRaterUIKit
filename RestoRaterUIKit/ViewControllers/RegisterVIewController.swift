//
//  RegisterVIewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

// Enum representing different types of rows in the registration form
enum RegisterRow {
    case name
    case email
    case password
    case registerButton
    case loginButton
}

// MARK: - RegisterViewController
final class RegisterViewController: UITableViewController {

    // MARK: - Properties
    private var viewModel = RegisterViewModel()
    private let rows: [RegisterRow] = [.name, .email, .password, .registerButton, .loginButton]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    // Configures the table view with necessary registrations and settings
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
    }
    
    // Binds view model properties to update the UI accordingly
    private func bindViewModel() {
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self else { return }
            if !message.isEmpty {
                AlertHelper.presentErrorAlert(on: self, message: message)
            }
        }
        
        viewModel.alertMessage.bind { [weak self] message in
            guard let self = self else { return }
            if !message.isEmpty {
                AlertHelper.presentErrorAlert(on: self, message: message, title: Lingo.commonSuccess, completion: {
                    self.navigateToLogin()
                })
            }
        }
    }
    // MARK: - Action Methods
    
    // Initiates the user registration process
    private func register() {
        Task {
            await viewModel.registerUser()
        }
    }
    // Navigates to the login view controller
    private func navigateToLogin() {
        let loginVC = LoginVIewController.instantiateFromAppStoryboard(appStoryboard: .Main)
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
}
// MARK: - TableView DataSource
extension RegisterViewController {
    // Number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    // Configure each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = rows[indexPath.row]
        switch fieldType {
            
        case .loginButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
            cell.configure(withTitle: Lingo.registerViewLoginButton) {
                self.navigateToLogin()
            }
            return cell
        case .registerButton:
            // Configuring for the register action
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.configure(withTitle: Lingo.registerViewRegisterButton) {
                self.register()
            }
            viewModel.isFormValid.bind { isValid in
                cell.buttonView.isEnabled = isValid
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            configureCell(cell, for: fieldType)
            return cell
        }
    }
    
    private func configureCell(_ cell: TextFieldCell, for fieldType: RegisterRow) {
        switch fieldType {
        case .name:
            cell.configure(title: Lingo.registerViewNamePlaceholder, content: viewModel.name) { [weak self] text, validationResult in
                self?.viewModel.name = text
                self?.viewModel.isNameValid = validationResult
            }
        case .email:
            cell.configure(title: Lingo.registerViewEmailPlaceholder, content: viewModel.email, validationType: .email) { [weak self] text, validationResult in
                self?.viewModel.email = text
                self?.viewModel.isEmailValid = validationResult
            }
        case .password:
            cell.configure(title: Lingo.registerViewPasswordPlaceholder, content: viewModel.password, validationType: .password, isSecureField: true) { [weak self] text, validationResult in
                self?.viewModel.password = text
                self?.viewModel.isPasswordValid = validationResult
            }
        default:
            break
        }
    }
}
