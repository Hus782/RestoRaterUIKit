//
//  UserListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

// MARK: - UserListViewController

final class UserListVIewController: UITableViewController {
    private let viewModel = UsersViewModel()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
        loadUsers()
    }
    
    // MARK: - Setup Methods
    
    // Configures the table view
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: UserTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.defaultReuseIdentifier)
    }
    
    // Sets up the navigation bar with an add button
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserAction))
        self.navigationItem.rightBarButtonItem = addButton
        title = Lingo.usersListTitle
    }
    
    // Loads the list of users
    private func loadUsers() {
        Task {
            await viewModel.fetchUsers()
            tableView.reloadData()
        }
    }
    
    // MARK: - User Actions
    
    // Handles the action to add a new user
    @objc private func addUserAction() {
        performSegue(withIdentifier: Segues.AddUserSegue.val, sender: self)
    }
    
    // Reloads the user data
    private func reloadData() {
        self.loadUsers()
        self.tableView.reloadData()
    }
    
    // Prepares for segues to user details or add user view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.UserDetailsSegue.val {
            if let userDetailsVC = segue.destination as? UserDetailsViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedUser = viewModel.users[indexPath.row]
                userDetailsVC.user = selectedUser
                userDetailsVC.hidesBottomBarWhenPushed = true
                userDetailsVC.deleteCompletion = { [weak self] in
                    self?.reloadData()
                }
            }
        } else if segue.identifier == Segues.AddUserSegue.val {
            if let vc = segue.destination as? AddEditUserViewController {
                vc.scenario = .add
                vc.completion = { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate

extension UserListVIewController {
    
    // Returns the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    // Configures each cell in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.defaultReuseIdentifier, for: indexPath) as! UserTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.configure(name: user.name, email: user.email, isAdmin: user.isAdmin)
        return cell
    }
    
    // Handles the selection of a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.UserDetailsSegue.val, sender: indexPath)
    }
}
