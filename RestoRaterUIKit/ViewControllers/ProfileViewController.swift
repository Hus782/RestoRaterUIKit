//
//  ProfileViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

struct DetailInfoCellData {
    let title: String
    let content: String
}

final class ProfileVIewController: UITableViewController {
    private var cells: [DetailInfoCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
        
        loadUserData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc private func logoutTapped() {
        UserManager.shared.logoutUser()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let navController = UINavigationController(rootViewController: loginVC)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.switchRootViewController(to: navController)
    }
    
    private func loadUserData() {
        guard let user = UserManager.shared.currentUser else {
            return // Add logic later
        }
        cells.append(DetailInfoCellData(title: Lingo.profileViewNameTitle, content: user.name))
        cells.append(DetailInfoCellData(title: Lingo.profileViewEmailTitle, content: user.email))
        let roleContent = user.isAdmin ? Lingo.profileViewAdminRole : Lingo.profileViewRegularUserRole
        cells.append(DetailInfoCellData(title: Lingo.profileViewRoleTitle, content: roleContent))
    }
}

extension ProfileVIewController {
  
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
