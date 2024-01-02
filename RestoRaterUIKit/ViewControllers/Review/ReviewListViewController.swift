//
//  ReviewListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

final class ReviewListVIewController: UITableViewController {
    private let viewModel = AddEditReviewViewModel(dataManager: CoreDataManager<Review>())
    var restaurant: Restaurant?
    private var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: ReviewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ReviewCell.defaultReuseIdentifier)
        
        loadRestaurants()
        
        title = "Reviews"
    }
    
    @objc private func addRestaurantAction() {
        performSegue(withIdentifier: "AddRestaurantSegue", sender: self)
    }
    
    private func loadRestaurants() {
        if let restaurant = restaurant, let fetchedReviews = restaurant.reviews?.allObjects as? [Review] {
            self.reviews = fetchedReviews
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditReviewSegue" {
            if let vc = segue.destination as? AddEditReviewViewController, let reviewToEdit = sender as? Review
            {
                vc.scenario = .edit
                vc.restaurant = restaurant
                vc.review = reviewToEdit
            }
        }
    }
    
    private func confirmAndDeleteReview(review: Review?) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.userDetailsDeleteConfirmation, preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { _ in
                Task {
                    let result = await self.viewModel.deleteReview(review)
                    continuation.resume(returning: result)
                }
            }))
            
            confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel, handler: { _ in
                continuation.resume(returning: .failure(CancellationError()))
            }))
            
            present(confirmAlert, animated: true)
        }
    }
    
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default))
        self.present(alert, animated: true)
    }
    
}

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
            
            Task {
                let reviewToDelete = self.reviews[indexPath.row]
                let result = await self.confirmAndDeleteReview(review: reviewToDelete)
                
                await MainActor.run {
                    switch result {
                    case .success:
                        self.reviews.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        completionHandler(true)
                    case .failure:
                        completionHandler(false)
                    }
                }
            }
        }
        
        // Swipe-to-Edit Action
        let editAction = UIContextualAction(style: .normal, title: Lingo.commonEdit) { [weak self] (action, view, completionHandler) in
            // Perform edit action
            let reviewToEdit = self?.reviews[indexPath.row]
            self?.performSegue(withIdentifier: "EditReviewSegue", sender: reviewToEdit)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    
}
