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

final class AddEditUserViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    private var cells: [DetailInfoCellData] = []
    private let fields: [UserField] = [.name, .email, .password, .isAdmin]
    weak var delegate: UserUpdateDelegate?
    var user: User?
    var scenario: UserViewScenario?
    var completion: (() -> Void)?
    private var activityIndicator: UIActivityIndicatorView?
    private let viewModel: AddEditUserViewModel = AddEditUserViewModel(dataManager: CoreDataManager<User>())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        initializeViewModel()
        setNavigationBar()
        setupActivityIndicator()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SwitchTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.defaultReuseIdentifier)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
    }
    
    private func initializeViewModel() {
        if let scenario = scenario, let user = user {
            viewModel.initializeWithUser(scenario: scenario, user: user)
        }
        
        viewModel.onAddCompletion = { [weak self] in
            self?.dismiss(animated: true)
            self?.completion?()
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.showLoading(isLoading)
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self else { return }
            if let message = message {
                ViewControllerHelper.presentErrorAlert(on: self, message: message)
            }
        }
    }
    
    private func setNavigationBar() {
        let navItem = UINavigationItem(title: viewModel.title)
        
        // Save item
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navItem.rightBarButtonItem = saveItem
        
        // Cancel item
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navItem.leftBarButtonItem = cancelItem
        
        navBar.setItems([navItem], animated: false)
    }
    
    @objc private func saveButtonTapped() {
        Task {
            await handleSave()
        }
    }
    
    private func showLoading(_ loading: Bool) {
        if loading {
            activityIndicator?.startAnimating()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator ?? UIView())
        } else {
            activityIndicator?.stopAnimating()
            let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveItem
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func handleSave() async {
        switch scenario {
        case .add:
            await viewModel.addUser()
        case .edit:
            if let updatedUser = await viewModel.editUser() {
                delegate?.userDidUpdate(updatedUser)
            }
        default:
            break
        }
    }
    
}

extension AddEditUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = fields[indexPath.row]
        switch fieldType {
        case .isAdmin:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.defaultReuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.configure(title: Lingo.addEditUserAdminAccess, description: Lingo.addEditUserAdminAccess, isOn: user?.isAdmin ?? false)
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
            cell.configure(title: Lingo.addEditUserName, content: viewModel.name) { [weak self] text in
                self?.viewModel.name = text
            }
        case .email:
            cell.configure(title: Lingo.addEditUserEmail, content: viewModel.email) { [weak self] text in
                self?.viewModel.email = text
            }
        case .password:
            cell.configure(title: Lingo.addEditUserPassword, content: viewModel.password) { [weak self] text in
                self?.viewModel.password = text
            }
        default:
            break
        }
    }
    
    
}
