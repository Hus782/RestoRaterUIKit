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

// Enum to represent different types of cells in the user details view
enum CellType {
    case info(DetailInfoCellData)
    case delete
}

// MARK: - UserDetailsViewController

final class UserDetailsViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let viewModel = UsersViewModel()
    private var cells: [CellType] = []
    var user: User?
    var deleteCompletion: (() -> Void)?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
        loadUserData()
    }
    
    // MARK: - Setup Methods
    
    // Configures the table view
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
    }
    
    // Sets up the navigation bar
    private func setupNavBar() {
        title = Lingo.userDetailsTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Lingo.commonEdit, style: .plain, target: self, action: #selector(editButtonTapped))
    }
    
    // MARK: - Action Methods
    
    // Handles the edit button tap
    @objc private func editButtonTapped() {
        performSegue(withIdentifier: Segues.EditUserSegue.val, sender: self)
        
    }
    
    // Loads user data into the view
    private func loadUserData() {
        guard let user = user else {
            return // Add logic later
        }
        cells = [
            .info(DetailInfoCellData(title: Lingo.userDetailsNameLabel, content: user.name)),
            .info(DetailInfoCellData(title: Lingo.userDetailsEmailLabel, content: user.email)),
            .info(DetailInfoCellData(title: Lingo.userDetailsRoleLabel, content: user.isAdmin ? Lingo.userDetailsRoleAdmin : Lingo.userDetailsRoleRegularUser))
        ]
        
        if !UserManager.shared.isCurrentUser(user: user) {
            cells.append(.delete)
        }
        
    }
    // Prepares for the segue to the edit user view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.EditUserSegue.val {
            if let vc = segue.destination as? AddEditUserViewController
            {
                vc.delegate = self
                vc.scenario = .edit
                vc.user = user
                vc.completion = self.deleteCompletion
            }
        }
    }
    
    // Confirms deletion and performs the deletion of the user
    private func confirmAndDeleteUser() {
        let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.userDetailsDeleteConfirmation, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { [weak self] _ in
            self?.performDeletion()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel))
        present(confirmAlert, animated: true)
    }
    
    // Performs the deletion process
    private func performDeletion() {
        Task {
            do {
                try await viewModel.deleteUser(user)
                deleteCompletion?()
                navigationController?.popViewController(animated: true)
            } catch {
                AlertHelper.presentErrorAlert(on: self, message: error.localizedDescription)
            }
        }
    }
    
}

// MARK: - TableView DataSource
extension UserDetailsViewController {
    
    // Returns the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    // Configures each cell in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .info(let cellData):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier, for: indexPath) as! DetailInfoTableViewCell
            cell.configure(title: cellData.title, content: cellData.content)
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
            cell.configure(withTitle: Lingo.commonDelete) { [weak self] in
                self?.confirmAndDeleteUser()
            }
            cell.button.setTitleColor(.red, for: .normal)
            return cell
        }
    }
}

// MARK: - UserUpdateDelegate

extension UserDetailsViewController: UserUpdateDelegate {
    // Updates the user information in the view
    func userDidUpdate(_ updatedUser: User) {
        self.user = updatedUser
        cells = []
        loadUserData()
        tableView.reloadData()
    }
}
