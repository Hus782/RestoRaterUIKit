//
//  AddEditReviewViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

// Enum representing different types of fields in the review form
enum ReviewField {
    case rating
    case date
    case comment
}

// MARK: - AddEditReviewViewController

final class AddEditReviewViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties for managing the form and review data
    private let fields: [ReviewField] = [.rating, .date, .comment]
    var restaurant: Restaurant?
    var review: Review?
    var scenario: ReviewViewScenario?
    var completion: (() -> Void)?
    
    private var activityIndicator: UIActivityIndicatorView?
    private let viewModel: AddEditReviewViewModel = AddEditReviewViewModel(dataManager: CoreDataManager<Review>())
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        initializeViewModel()
        setNavigationBar()
        setupActivityIndicator()
    }
    
    // MARK: - Setup Methods
    
    // Configures the table view
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: TextViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TextViewCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: DatePickerCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DatePickerCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: RatingPickerCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RatingPickerCell.defaultReuseIdentifier)
    }
    
    // Sets up the activity indicator
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
    }
    
    // Initializes the view model with review data and scenario
    private func initializeViewModel() {
        if let scenario = scenario, let restaurant = restaurant {
            viewModel.initialize(scenario: scenario, restaurant: restaurant, review: review)
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
                guard let self = self else { return }
                AlertHelper.presentErrorAlert(on: self, message: message)
            }
        }
    }
    
    // Sets up the navigation bar with save and cancel options
    private func setNavigationBar() {
        let navItem = UINavigationItem(title: viewModel.title)
        
        // Save button
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navItem.rightBarButtonItem = saveItem
        
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
            let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveItem
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // Processes the save action based on the scenario (add or edit)
    private func handleSave() async {
        switch scenario {
        case .add:
            await viewModel.addReview()
        case .edit:
            await viewModel.editReview()
        default:
            break
        }
    }
    
}

// MARK: - TableView DataSource and Delegate

extension AddEditReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = fields[indexPath.row]
        switch fieldType {
        case .comment:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.defaultReuseIdentifier, for: indexPath) as! TextViewCell
            cell.configure(title: Lingo.addEditReviewComment, content: viewModel.comment) { [weak self] text in
                self?.viewModel.comment = text
            }
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.defaultReuseIdentifier, for: indexPath) as! DatePickerCell
            cell.configure(withTitle: Lingo.addEditReviewDateOfVisit, date: viewModel.visitDate) { [weak self] newDate in
                self?.viewModel.visitDate = newDate
            }
            return cell
            
        case .rating:
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingPickerCell.defaultReuseIdentifier, for: indexPath) as! RatingPickerCell
            cell.configure(withRating: Int(review?.rating ?? 0)) { [weak self] newRating in
                self?.viewModel.rating = newRating
            }
            return cell
        }
    }
    
}
