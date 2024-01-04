//
//  AddEditUserViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

// Enum representing different types of fields in the user form
enum UserField {
    case name
    case email
    case password
    case isAdmin
}

// MARK: - AddEditUserViewController

final class AddEditUserViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties for managing the form and user data
    private var cells: [DetailInfoCellData] = []
    private let fields: [UserField] = [.name, .email, .password, .isAdmin]
    weak var delegate: UserUpdateDelegate?
    var user: User?
    var scenario: UserViewScenario?
    var completion: (() -> Void)?
    
    private var activityIndicator: UIActivityIndicatorView?
    private var saveButtonItem: UIBarButtonItem?
    private let viewModel: AddEditUserViewModel = AddEditUserViewModel(dataManager: CoreDataManager<User>())
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setNavigationBar()
        setupActivityIndicator()
        initializeViewModel()
    }
    
    // MARK: - Setup Methods
    
    // Configures the table view
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextFieldCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SwitchTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.defaultReuseIdentifier)
    }
    
    // Sets up the activity indicator
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
    }
    
    // Initializes the view model with user data and scenario
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
                AlertHelper.presentErrorAlert(on: self, message: message)
            }
        }
        
        viewModel.isFormValid.bind { [weak self]  isValid in
            self?.saveButtonItem?.isEnabled = isValid
        }
    }
    
    // Sets up the navigation bar with save and cancel options
    private func setNavigationBar() {
        let navItem = UINavigationItem(title: viewModel.title)
        
        // Save button
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navItem.rightBarButtonItem = saveItem
        saveButtonItem = saveItem
        
        // Cancel button
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navItem.leftBarButtonItem = cancelItem
        
        navBar.setItems([navItem], animated: false)
    }
    
    // MARK: - Action Methods
    
    // Handles the save button tap
    @objc private func saveButtonTapped() {
        Task {
            await handleSave()
        }
    }
    
    // Shows or hides the loading indicator
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
    
    // Handles the cancel button tap
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // Processes the save action based on the scenario (add or edit)
    private func handleSave() async {
        guard let scenario = scenario else { return }
        switch scenario {
        case .add:
            await viewModel.addUser()
        case .edit:
            if let updatedUser = await viewModel.editUser() {
                delegate?.userDidUpdate(updatedUser)
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate

extension AddEditUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Returns the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    // Configures each cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = fields[indexPath.row]
        switch fieldType {
        case .isAdmin:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.defaultReuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.configure(title: Lingo.addEditUserAdminAccess, description: Lingo.addEditUserAdminAccess, isOn: user?.isAdmin ?? false) { [weak self] isOn in
                self?.viewModel.isAdmin = isOn
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            configureCell(cell, for: fieldType)
            return cell
        }
    }
    
    // Configures the text field cell based on the field type
    private func configureCell(_ cell: TextFieldCell, for fieldType: UserField) {
        switch fieldType {
        case .name:
            cell.configure(title: Lingo.addEditUserName, content: viewModel.name) { [weak self] text, validationResult in
                self?.viewModel.name = text
                self?.viewModel.isNameValid = validationResult
            }
        case .email:
            cell.configure(title: Lingo.addEditUserEmail, content: viewModel.email, validationType: .email) { [weak self] text, validationResult in
                self?.viewModel.email = text
                self?.viewModel.isEmailValid = validationResult
            }
        case .password:
            cell.configure(title: Lingo.addEditUserPassword, content: viewModel.password, validationType: .password, isSecureField: true) { [weak self] text, validationResult in
                self?.viewModel.password = text
                self?.viewModel.isPasswordValid = validationResult
            }
        default:
            break
        }
    }
}
