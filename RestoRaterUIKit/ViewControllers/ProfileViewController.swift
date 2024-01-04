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
        
        setupTableView()
        loadUserData()
        setupNavBar()
        
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
    }
    
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Lingo.profileViewLogoutButton, style: .plain, target: self, action: #selector(logoutTapped))
        
        title = Lingo.profileViewTitle
    }
    
    @objc private func logoutTapped() {
        UserManager.shared.logoutUser()
        let loginVC = LoginVIewController.instantiateFromAppStoryboard(appStoryboard: .Main)
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
