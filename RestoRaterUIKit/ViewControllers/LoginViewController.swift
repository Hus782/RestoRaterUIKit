//
//  LoginViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

enum LoginRow {
    case email
    case password
    case registerButton
    case loginButton
}

final class LoginVIewController: UITableViewController {
    
    private var viewModel = LoginViewModel()
    private let rows: [LoginRow] = [.email, .password, .loginButton, .registerButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindViewModel()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.alertMessage.bind { [weak self] message in
            guard let self = self else { return }
            if !message.isEmpty {
                ViewControllerHelper.presentErrorAlert(on: self, message: message)
            }
        }
    }
    
    private func login() {
        Task {
            await viewModel.loginUser() { [weak self] in
                self?.navigateToTabBar()
            }
        }
    }
    
    private func navigateToTabBar() {
        guard let user = UserManager.shared.currentUser else {
            return
        }
        let tabBarController = TabBarController(isAdmin: user.isAdmin)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.switchRootViewController(to: tabBarController)
    }
    
    private func navigateToRegister() {
        let registerVC = RegisterViewController.instantiateFromAppStoryboard(appStoryboard: .Main)
        navigationController?.setViewControllers([registerVC], animated: true)
    }
}

extension LoginVIewController {
    // Number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = rows[indexPath.row]
        switch fieldType {
            
        case .loginButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.configure(withTitle: Lingo.loginViewLoginButton) {
                self.login()
            }
            viewModel.isFormValid.bind { isValid in
                cell.buttonView.isEnabled = isValid
            }
            return cell
        case .registerButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
            cell.configure(withTitle: Lingo.loginViewRegisterButton) {
                self.navigateToRegister()
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            configureCell(cell, for: fieldType)
            return cell
        }
    }
    
    private func configureCell(_ cell: TextFieldCell, for fieldType: LoginRow) {
        switch fieldType {
        case .email:
            cell.configure(title: Lingo.loginViewEmailPlaceholder, content: viewModel.email, validationType: .email) { [weak self] text, validationResult in
                self?.viewModel.email = text
                self?.viewModel.isEmailValid = validationResult
            }
        case .password:
            cell.configure(title: Lingo.loginViewPasswordPlaceholder, content: viewModel.password, validationType: .none, isSecureField: true) { [weak self] text, validationResult in
                self?.viewModel.password = text
                self?.viewModel.isPasswordValid = validationResult
                
            }
        default:
            break
        }
    }
}
