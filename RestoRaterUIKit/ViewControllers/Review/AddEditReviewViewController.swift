//
//  AddEditReviewViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

enum ReviewField {
    case rating
    case date
    case comment
}

final class AddEditReviewViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    private let fields: [ReviewField] = [.rating, .date, .comment]
    var restaurant: Restaurant?
    var review: Review?
    var scenario: ReviewViewScenario?
    var completion: (() -> Void)?
    private var activityIndicator: UIActivityIndicatorView?
    private let viewModel: AddEditReviewViewModel = AddEditReviewViewModel(dataManager: CoreDataManager<Review>())
    
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
        tableView.register(UINib(nibName: DatePickerCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: DatePickerCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: RatingPickerCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RatingPickerCell.defaultReuseIdentifier)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
    }
    
    private func initializeViewModel() {
        if let scenario = scenario, let review = review, let restaurant = restaurant {
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
            await viewModel.addReview()
        case .edit:
            if let updatedUser = await viewModel.editUser() {
//                delegate?.userDidUpdate(updatedUser)
            }
        default:
            break
        }
    }
    
}

extension AddEditReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = fields[indexPath.row]
        switch fieldType {
        case .comment:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier, for: indexPath) as! TextFieldCell
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
