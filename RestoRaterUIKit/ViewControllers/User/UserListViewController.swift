//
//  UserListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

final class UserListVIewController: UITableViewController {
    private var viewModel = UsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
        loadUsers()
        
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: UserTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.defaultReuseIdentifier)
    }
    
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserAction))
        self.navigationItem.rightBarButtonItem = addButton
        title = Lingo.usersListTitle

    }
    
    private func loadUsers() {
        Task {
            await viewModel.fetchUsers()
            tableView.reloadData()
        }
    }
    
    @objc private func addUserAction() {
        performSegue(withIdentifier: Segues.AddUserSegue.val, sender: self)
    }
    
    private func reloadData() {
        self.loadUsers()
        self.tableView.reloadData()
    }
    
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
            if let vc = segue.destination as? AddEditUserViewController
            {
                vc.scenario = .add
                vc.completion = { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.reloadData()
                }
            }
        }
    }
    
}

extension UserListVIewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.defaultReuseIdentifier, for: indexPath) as! UserTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.configure(name: user.name, email: user.email, isAdmin: user.isAdmin)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.UserDetailsSegue.val, sender: indexPath)
    }

}
