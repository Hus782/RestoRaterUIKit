//
//  ProfileViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

// Structure to hold the data for each cell in the profile view
struct DetailInfoCellData {
    let title: String
    let content: String
}

// MARK: - ProfileViewController

final class ProfileVIewController: UITableViewController {
    
    // MARK: - Properties
    
    // Holds the data to be displayed in each cell
    private var cells: [DetailInfoCellData] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadUserData()
        setupNavBar()
    }
    
    // MARK: - Setup Methods
    
    // Configures the table view
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
    }
    
    // Sets up the navigation bar, including the logout button
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Lingo.profileViewLogoutButton, style: .plain, target: self, action: #selector(logoutTapped))
        title = Lingo.profileViewTitle
    }
    
    // MARK: - User Actions
    
    // Handles the logout action
    @objc private func logoutTapped() {
        UserManager.shared.logoutUser()
        let loginVC = LoginVIewController.instantiateFromAppStoryboard(appStoryboard: .Main)
        let navController = UINavigationController(rootViewController: loginVC)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.switchRootViewController(to: navController)
    }
    
    // Loads and prepares user data for display
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

// MARK: - TableView DataSource

extension ProfileVIewController {
    
    // Returns the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    // Configures each cell in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier, for: indexPath) as! DetailInfoTableViewCell
        let cellData = cells[indexPath.row]
        cell.configure(title: cellData.title, content: cellData.content)
        return cell
    }
}
