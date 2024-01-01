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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: RestaurantHeaderCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RestaurantHeaderCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: StarRatingCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: StarRatingCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ReviewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ReviewCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: SecondaryButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: SecondaryButtonCell.defaultReuseIdentifier)
        tableView.register(UINib(nibName: ButtonCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonCell.defaultReuseIdentifier)
        
        
        
        title = Lingo.userDetailsTitle
        loadRestaurant()
        
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
            }
        }
    }
    
    private func confirmAndDeleteRestaurant() {
        let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.userDetailsDeleteConfirmation, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { [weak self] _ in
            Task {
                let result = await self?.viewModel.deleteRestaurant(self?.restaurant)
                switch result {
                case .success:
                    self?.deleteCompletion?()
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presentErrorAlert(message: error.localizedDescription)
                    }
                case .none:
                    break
                }
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel))
        
        present(confirmAlert, animated: true)
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default))
        self.present(alert, animated: true)
    }
    
    private func showAllReviews() {
        
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
            cell.configure(date: review.visitDate, commnent: review.comment, rating: Double(review.rating), reviewType: reviewType)
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
