//
//  UserListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

class UserListVIewController: UITableViewController {
    private var viewModel = UsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: UserTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.defaultReuseIdentifier)
        
        loadUsers()
    }
    
    private func loadUsers() {
          Task {
              await viewModel.fetchUsers()
              tableView.reloadData()
          }
      }
}

extension UserListVIewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.defaultReuseIdentifier, for: indexPath) as! UserTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.configure(name: user.name, email: user.email, isAdmin: user.isAdmin)
        return cell
    }
}
