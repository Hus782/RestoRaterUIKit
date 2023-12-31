//
//  UserDetailsViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

// Used to update the current user after editing
protocol UserUpdateDelegate: AnyObject {
    func userDidUpdate(_ updatedUser: User)
}

final class UserDetailsViewController: UITableViewController {
    private var cells: [DetailInfoCellData] = []
    var user: User?
    var deleteCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
        
        title = Lingo.userDetailsTitle
        loadUserData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        
    }
    
    @objc private func editButtonTapped() {
        performSegue(withIdentifier: "EditUserSegue", sender: self)
        
    }
    
    private func loadUserData() {
        guard let user = user else {
            return // Add logic later
        }
        cells.append(DetailInfoCellData(title: Lingo.userDetailsNameLabel, content: user.name))
        cells.append(DetailInfoCellData(title: Lingo.userDetailsEmailLabel, content: user.email))
        let roleContent = user.isAdmin ? Lingo.userDetailsRoleAdmin  : Lingo.userDetailsRoleRegularUser
        cells.append(DetailInfoCellData(title: Lingo.userDetailsRoleLabel, content: roleContent))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUserSegue" {
            if let vc = segue.destination as? AddEditUserViewController
            {
                vc.delegate = self
                vc.scenario = .edit
                vc.user = user
            }
        }
    }
    
}

extension UserDetailsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier, for: indexPath) as! DetailInfoTableViewCell
        let cellData = cells[indexPath.row]
        cell.configure(title: cellData.title, content: cellData.content)
        return cell
    }
}

extension UserDetailsViewController: UserUpdateDelegate {
    func userDidUpdate(_ updatedUser: User) {
        self.user = updatedUser
        cells = []
        loadUserData()
        tableView.reloadData()
    }
}
