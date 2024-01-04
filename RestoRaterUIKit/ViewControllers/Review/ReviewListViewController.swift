//
//  ReviewListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

// MARK: - ReviewListViewController

final class ReviewListVIewController: UITableViewController {
    private let viewModel = AddEditReviewViewModel(dataManager: CoreDataManager<Review>())
    var restaurant: Restaurant?
    private var reviews: [Review] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadReviews()
        title = Lingo.reviewListTitle
    }
    
    // MARK: - Setup Methods
    
    // Configures the table view
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ReviewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ReviewCell.defaultReuseIdentifier)
    }
    
    // Loads reviews for the specified restaurant
    private func loadReviews() {
        if let restaurant = restaurant, let fetchedReviews = restaurant.reviews?.allObjects as? [Review] {
            self.reviews = fetchedReviews
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    // Prepares for the segue to the edit review view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.EditReviewSegue.val {
            if let vc = segue.destination as? AddEditReviewViewController, let reviewToEdit = sender as? Review {
                vc.scenario = .edit
                vc.restaurant = restaurant
                vc.review = reviewToEdit
                vc.completion = { [weak self] in
                    self?.loadReviews()
                }
            }
        }
    }
    
    // MARK: - User Actions
    
    // Confirms and initiates the deletion of a review
    private func confirmAndDeleteReview(review: Review?, completion: @escaping (Bool) -> Void) {
        let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.reviewsListViewConfirmDeleteMessage, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return completion(false) }
            
            Task {
                do {
                    try await self.viewModel.deleteReview(review)
                    completion(true)
                } catch {
                    AlertHelper.presentErrorAlert(on: self, message: error.localizedDescription)
                    completion(false)
                }
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel, handler: { _ in
            completion(false)
        }))
        present(confirmAlert, animated: true)
    }
}

// MARK: - TableView DataSource and Delegate

extension ReviewListVIewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.defaultReuseIdentifier, for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        
        cell.configure(date: review.visitDate, comment: review.comment, rating: Double(review.rating), reviewType: .normal)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            // Swipe-to-Delete Action
            let deleteAction = UIContextualAction(style: .destructive, title: Lingo.commonDelete) { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                
                let reviewToDelete = self.reviews[indexPath.row]
                self.confirmAndDeleteReview(review: reviewToDelete, completion: { success in
                    completionHandler(success)
                    if success {
                        // Update your data source and table view
                        self.reviews.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                })
            }
            
            // Swipe-to-Edit Action
            let editAction = UIContextualAction(style: .normal, title: Lingo.commonEdit) { [weak self] (action, view, completionHandler) in
                // Perform edit action
                let reviewToEdit = self?.reviews[indexPath.row]
                self?.performSegue(withIdentifier: Segues.EditReviewSegue.val, sender: reviewToEdit)
                completionHandler(true)
            }
            editAction.backgroundColor = UIColor.blue
            
        if UserManager.shared.currentUser?.isAdmin ?? false {
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            return configuration
        } else {
            return nil
        }
    }
    
    
}
