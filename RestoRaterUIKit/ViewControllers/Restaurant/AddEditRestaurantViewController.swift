//
//  AddEditRestaurantViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

// Enum representing different types of fields in the restaurant form
enum RestaurantField {
    case name
    case address
    case image
}

// MARK: - AddEditRestaurantViewController

final class AddEditRestaurantViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!

    // Properties for managing the form and restaurant data
    private var cells: [DetailInfoCellData] = []
    private let fields: [RestaurantField] = [.name, .address, .image]
    var restaurant: Restaurant?
    weak var delegate: RestaurantUpdateDelegate?
    var scenario: RestaurantViewScenario = .add
    var completion: (() -> Void)?
    
    private var activityIndicator: UIActivityIndicatorView?
    private var saveButtonItem: UIBarButtonItem?
    private let viewModel: AddEditRestaurantViewModel = AddEditRestaurantViewModel(dataManager: CoreDataManager<Restaurant>())
    
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
        tableView.register(UINib(nibName: ImagePickerCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ImagePickerCell.defaultReuseIdentifier)
    }
    
    // Sets up the activity indicator
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
    }
    
    // Initializes the view model with restaurant data and scenario
    private func initializeViewModel() {
        if let restaurant = restaurant {
            viewModel.initializeWithRestaurant(scenario: scenario, restaurant: restaurant)
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
    
    // MARK: - User Actions

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
            navigationItem.rightBarButtonItem = saveButtonItem
        }
    }
    
    // Handles the cancel button tap
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // Processes the save action based on the scenario (add or edit)
    private func handleSave() async {
        switch scenario {
        case .add:
            await viewModel.addRestaurant()
        case .edit:
            if let updatedRestaurant = await viewModel.editRestaurant() {
                delegate?.restaurantDidUpdate(updatedRestaurant)
            }
        }
    }
    
    // Presents the image picker to choose a restaurant image
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate

extension AddEditRestaurantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
         picker.dismiss(animated: true)
         if let image = info[.originalImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 1.0) {
             viewModel.image = imageData
             tableView.reloadData()
         }
     }
}

// MARK: - TableView DataSource and Delegate

extension AddEditRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = fields[indexPath.row]
        switch fieldType {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagePickerCell.defaultReuseIdentifier, for: indexPath) as! ImagePickerCell
            cell.pickImageAction = { [weak self] in
                self?.presentImagePicker()
            }
            // Configure the cell with existing image if any
            cell.pickedImageView.image = UIImage(data: viewModel.image)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
            configureCell(cell, for: fieldType)
            return cell
        }
    }
    
    
    private func configureCell(_ cell: TextFieldCell, for fieldType: RestaurantField) {
        switch fieldType {
        case .name:
            cell.configure(title: Lingo.addEditUserName, content: viewModel.name) { [weak self]text, validationResult in
                self?.viewModel.name = text
                self?.viewModel.isNameValid = validationResult
            }
        case .address:
            cell.configure(title: Lingo.addEditRestaurantAddress, content: viewModel.address) { [weak self] text, validationResult in
                self?.viewModel.address = text
                self?.viewModel.isAddressValid = validationResult
            }
        default:
            break
        }
    }
    
    
}
