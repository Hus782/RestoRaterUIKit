//
//  RegisterVIewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

class RegisterViewController: UITableViewController {
    private var viewModel = RegisterViewModel()
    
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
    
    // Number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // Configure each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // Configuring for name input
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(title: Lingo.registerViewNamePlaceholder)
            cell.textChanged = { [weak self] text in
                self?.viewModel.name.value = text
            }
            cell.textField.text = viewModel.name.value
            return cell
        case 1:
            // Configuring for email input
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(title: Lingo.registerViewEmailPlaceholder)
            cell.textChanged = { [weak self] text in
                self?.viewModel.email.value = text
            }
            cell.textField.text = viewModel.email.value
            return cell
        case 2:
            // Configuring for password input
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(title: Lingo.registerViewPasswordPlaceholder)
            cell.textChanged = { [weak self] text in
                self?.viewModel.password.value = text
            }
            cell.textField.text = viewModel.password.value
            return cell
        case 3:
            // Configuring for the register action
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.configure(withTitle: Lingo.registerViewRegisterButton) {
                self.register()
            }
            return cell
        case 4:
            // Configuring for the register action
            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
            cell.configure(withTitle: Lingo.registerViewLoginButton) {
                self.navigateToLogin()
            }
            return cell
        default:
            fatalError("Unknown row in section")
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
        navigationController?.setViewControllers([registerVC], animated: false)
    }
    
}
