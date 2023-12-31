//
//  AddEditUserViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

enum UserField {
    case name
    case email
    case password
    case isAdmin
}

final class AddEditUserViewController: UITableViewController {
    private var cells: [DetailInfoCellData] = []
    private let fields: [UserField] = [.name, .email, .password, .isAdmin]

    var user: User?
    var scenario: UserViewScenario?
    private var viewModel: AddEditUserViewModel = AddEditUserViewModel(dataManager: CoreDataManager<User>())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SwitchTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.defaultReuseIdentifier)
        title = Lingo.userDetailsTitle
        
        if let scenario = scenario, let user = user {
            viewModel.initializeWithUser(scenario: scenario, user: user)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(editButtonTapped))
    }
    
    @objc private func editButtonTapped() {
        Task {
            await viewModel.addUser()
        }
    }
}

extension AddEditUserViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = fields[indexPath.row]
        switch fieldType {
        case .isAdmin:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.defaultReuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.configure(title: "Role", description: "isAdmin", isOn: user?.isAdmin ?? false)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            configureCell(cell, for: fieldType)
            return cell
        }
    }

    
    private func configureCell(_ cell: TextFieldCell, for fieldType: UserField) {
        switch fieldType {
        case .name:
            cell.configure(title: Lingo.addEditUserName)
            cell.textField.text = viewModel.name
            cell.textChanged = { [weak self] text in
                self?.viewModel.name = text
            }
        case .email:
            cell.configure(title: Lingo.addEditUserEmail)
            cell.textField.text = viewModel.email
            cell.textChanged = { [weak self] text in
                self?.viewModel.email = text
            }
        case .password:
            cell.configure(title: Lingo.addEditUserPassword)
            cell.textField.text = viewModel.password
            cell.textChanged = { [weak self] text in
                self?.viewModel.password = text
            }
        default:
            break
        }
    }

    
}
