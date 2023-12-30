//
//  UserDetailsViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

final class UserDetailsViewController: UITableViewController {
    private var cells: [DetailInfoCellData] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
        
        title = Lingo.userDetailsTitle
        loadUserData()
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
