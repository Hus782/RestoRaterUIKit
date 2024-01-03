//
//  RestaurantDetailsViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

struct RestaurantHeaderData {
    let name: String
    let address: String
    let imageData: Data
}

enum ReviewType {
    case latest
    case highestRated
    case lowestRated
    case normal
}

final class RestaurantDetailsViewController: UITableViewController {
    private enum CellType {
        case header(RestaurantHeaderData)
        case rating(Double)
        case review(ReviewType, Review)
        case showAllReviews
        case addReview
    }
    
    private var viewModel = RestaurantViewModel()
    private var cells: [CellType] = []
    var restaurant: Restaurant?
    var deleteCompletion: (() -> Void)?
    var editCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        title = Lingo.restaurantDetailTitle
        loadRestaurant()
        setupMoreButton()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: RestaurantHeaderCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RestaurantHeaderCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: StarRatingCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: StarRatingCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ReviewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ReviewCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonCell.defaultReuseIdentifier)
    }
    
    private func setupMoreButton() {
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreButtonTapped))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    @objc private func moreButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: Lingo.commonEdit, style: .default) { [weak self] _ in
            self?.editButtonTapped()
        }
        
        let deleteAction = UIAlertAction(title: Lingo.commonDelete, style: .destructive) { [weak self] _ in
            self?.confirmAndDeleteRestaurant()
        }
        
        let cancelAction = UIAlertAction(title: Lingo.commonCancel, style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    
    
    @objc private func editButtonTapped() {
        performSegue(withIdentifier: "EditRestaurantSegue", sender: self)
        
    }
    
    
    private func loadRestaurant() {
        guard let restaurant = restaurant else {
            return // Add logic later
        }
        
        cells = [
            .header(RestaurantHeaderData(name: restaurant.name, address: restaurant.address, imageData: restaurant.image)),
            .rating(restaurant.averageRating)
        ]
        if restaurant.hasReviews {
            if let latest = restaurant.latestReview {
                cells.append(.review(.latest, latest))
            }
            if let highest = restaurant.highestRatedReview {
                cells.append(.review(.highestRated, highest))
            }
            if let lowest = restaurant.lowestRatedReview {
                cells.append(.review(.lowestRated, lowest))
            }
            cells.append(.showAllReviews)
        }
        cells.append(.addReview)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRestaurantSegue" {
            if let vc = segue.destination as? AddEditRestaurantViewController
            {
                vc.scenario = .edit
                vc.restaurant = restaurant
                vc.completion = deleteCompletion
                vc.delegate = self
            }
        } else   if segue.identifier == "AddReviewSegue" {
            if let vc = segue.destination as? AddEditReviewViewController
            {
                vc.scenario = .add
                vc.restaurant = restaurant
                vc.completion = deleteCompletion
            }
        } else   if segue.identifier == "ShowAllReviewsSegue" {
            if let vc = segue.destination as? ReviewListVIewController
            {
                vc.restaurant = restaurant
            }
        }
    }
    
    private func confirmAndDeleteRestaurant() {
        let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.restaurantDetailConfirmDeleteMessage, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { [weak self] _ in
            self?.performDeletion()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel))
        present(confirmAlert, animated: true)
    }
    
    private func performDeletion() {
        Task {
            do {
                try await viewModel.deleteRestaurant(restaurant)
                deleteCompletion?()
                navigationController?.popViewController(animated: true)
            } catch {
                ViewControllerHelper.presentErrorAlert(on: self, message: error.localizedDescription)
            }
        }
    }
    
    private func showAllReviews() {
        performSegue(withIdentifier: "ShowAllReviewsSegue", sender: nil)
    }
    
    private func addReview() {
        performSegue(withIdentifier: "AddReviewSegue", sender: nil)
    }
}

extension RestaurantDetailsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
            
        case .header(let restaurantData):
            let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantHeaderCell.defaultReuseIdentifier, for: indexPath) as! RestaurantHeaderCell
            cell.configure(name: restaurantData.name, address: restaurantData.address, imageData: restaurantData.imageData)
            return cell
        case .rating(let rating):
            let cell = tableView.dequeueReusableCell(withIdentifier: StarRatingCell.defaultReuseIdentifier, for: indexPath) as! StarRatingCell
            cell.configure(withRating: rating)
            return cell
        case .review(let reviewType, let review):
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.defaultReuseIdentifier, for: indexPath) as! ReviewCell
            cell.configure(date: review.visitDate, comment: review.comment, rating: Double(review.rating), reviewType: reviewType)
            return cell
        case .showAllReviews:
            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
            cell.configure(withTitle: Lingo.restaurantDetailShowAllReviews) { [weak self] in
                self?.showAllReviews()
            }
            return cell
        case .addReview:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.configure(withTitle: Lingo.restaurantDetailAddReview) { [weak self] in
                self?.addReview()
            }
            return cell
        }
    }
}

extension RestaurantDetailsViewController: RestaurantUpdateDelegate {
    func restaurantDidUpdate(_ updatedRestaurant: Restaurant) {
        self.restaurant = updatedRestaurant
        cells = []
        loadRestaurant()
        tableView.reloadData()
    }
}
