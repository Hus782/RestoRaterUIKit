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
    private enum CellType {
        case info(DetailInfoCellData)
        case delete
    }
    private var viewModel = UsersViewModel()
    private var cells: [CellType] = []
    var user: User?
    var deleteCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: DetailInfoTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailInfoTableViewCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
        
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
        cells = [
            .info(DetailInfoCellData(title: Lingo.userDetailsNameLabel, content: user.name)),
            .info(DetailInfoCellData(title: Lingo.userDetailsEmailLabel, content: user.email)),
            .info(DetailInfoCellData(title: Lingo.userDetailsRoleLabel, content: user.isAdmin ? Lingo.userDetailsRoleAdmin : Lingo.userDetailsRoleRegularUser))
        ]
        
        if !UserManager.shared.isCurrentUser(user: user) {
            cells.append(.delete)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUserSegue" {
            if let vc = segue.destination as? AddEditUserViewController
            {
                vc.delegate = self
                vc.scenario = .edit
                vc.user = user
                vc.completion = self.deleteCompletion
            }
        }
    }
    
    private func confirmAndDeleteUser() {
        let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.userDetailsDeleteConfirmation, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { [weak self] _ in
            Task {
                let result = await self?.viewModel.deleteUser(self?.user)
                switch result {
                case .success:
                    self?.deleteCompletion?()
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presentErrorAlert(message: error.localizedDescription)
                    }
                case .none:
                    break
                }
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel))
        
        present(confirmAlert, animated: true)
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default))
        self.present(alert, animated: true)
    }
    
}

extension UserDetailsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
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

extension UserDetailsViewController: UserUpdateDelegate {
    func userDidUpdate(_ updatedUser: User) {
        self.user = updatedUser
        cells = []
        loadUserData()
        tableView.reloadData()
    }
}
