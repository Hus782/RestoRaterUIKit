//
//  LoginViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

class LoginVIewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
    }
    
    // Number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // Configure each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // Configuring for email input
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(title: "Name")
            return cell
        case 1:
            // Configuring for password input
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            cell.configure(title: "Password")
            return cell
        case 2:
            // Configuring for the login action
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.configure(withTitle: "Login") {
                self.login()
            }
            return cell
        case 3:
            // Configuring for the login action
            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
            cell.configure(withTitle: "Create account") {
                self.navigateToRegister()
            }
            return cell
        default:
            fatalError("Unknown row in section")
        }
    }
    
    
    private func login() {

    }
    
    private func navigateToRegister() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.setViewControllers([registerVC], animated: false)
    }
}

