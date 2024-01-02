//
//  RegisterVIewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

final class RegisterViewController: UITableViewController {
    private enum RegisterRow {
        case name
        case email
        case password
        case registerButton
        case loginButton
    }
    
    private var viewModel = RegisterViewModel()
    private let rows: [RegisterRow] = [.name, .email, .password, .registerButton, .loginButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.showingAlert.bind { [weak self] showing in
            if showing {
                self?.presentAlert(message: self?.viewModel.alertMessage.value ?? "")
            }
        }
    }
    
    private func presentAlert(message: String) {
        let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
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
            cell.configure(title: Lingo.registerViewNamePlaceholder, content: viewModel.name.value, validationType: .email) { [weak self] text in
                self?.viewModel.name.value = text
            }
        case .email:
            cell.configure(title: Lingo.registerViewEmailPlaceholder, content: viewModel.email.value, validationType: .email) { [weak self] text in
                self?.viewModel.email.value = text
            }
        case .password:
            cell.configure(title: Lingo.registerViewPasswordPlaceholder, content: viewModel.password.value, validationType: .email) { [weak self] text in
                self?.viewModel.password.value = text
            }
        default:
            break
        }
    }
    
    private func register() {
        Task {
            await viewModel.registerUser()
        }
    }
    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.setViewControllers([registerVC], animated: true)
    }
    
}
