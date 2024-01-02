//
//  AddEditRestaurantViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

enum RestaurantField {
    case name
    case address
    case image
}

final class AddEditRestaurantViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    private var cells: [DetailInfoCellData] = []
    private let fields: [RestaurantField] = [.name, .address, .image]
    var restaurant: Restaurant?
    var scenario: RestaurantViewScenario = .add
    var completion: (() -> Void)?
    private var activityIndicator: UIActivityIndicatorView?
    private let viewModel: AddEditRestaurantViewModel = AddEditRestaurantViewModel(dataManager: CoreDataManager<Restaurant>())
    
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
        tableView.register(UINib(nibName: ImagePickerCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ImagePickerCell.defaultReuseIdentifier)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
    }
    
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
            if let message = message {
                self?.presentErrorAlert(message: message)
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
    
    private func presentErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default))
            self.present(alert, animated: true)
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
            await viewModel.addRestaurant()
        case .edit:
            if let updatedUser = await viewModel.editRestaurant() {
//                delegate?.userDidUpdate(updatedUser)
            }
        default:
            break
        }
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

}

extension AddEditRestaurantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
         picker.dismiss(animated: true)
         if let image = info[.originalImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 1.0) {
             viewModel.image = imageData
             tableView.reloadData()
         }
     }
}

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
            cell.pickedImageView.image = UIImage(data: viewModel.image ?? Data())
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
            }
        case .address:
            cell.configure(title: Lingo.addEditRestaurantAddress, content: viewModel.address) { [weak self] text, validationResult in
                self?.viewModel.address = text
            }
        default:
            break
        }
    }
    
    
}
