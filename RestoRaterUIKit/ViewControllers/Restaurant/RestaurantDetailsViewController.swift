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

final class RestaurantDetailsViewController: UITableViewController {
    private enum CellType {
        case header(RestaurantHeaderData)
        case rating(Double)
        case review(Review)
        case showAllReviews
    }

    private var viewModel = RestaurantViewModel()
    private var cells: [CellType] = []
    var restaurant: Restaurant?
    var deleteCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: RestaurantHeaderCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RestaurantHeaderCell.defaultReuseIdentifier)
  
        
        title = Lingo.userDetailsTitle
        loadRestaurant()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        
    }
    
    @objc private func editButtonTapped() {
        performSegue(withIdentifier: "EditUserSegue", sender: self)
        
    }
    
    private func loadRestaurant() {
        guard let restaurant = restaurant else {
            return // Add logic later
        }
        
        cells = [
            .header(RestaurantHeaderData(name: restaurant.name, address: restaurant.address, imageData: restaurant.image)),
            .rating(restaurant.averageRating)
        ]
        if restaurant.hasReviews, let latest = restaurant.latestReview, let highest = restaurant.highestRatedReview, let lowest = restaurant.lowestRatedReview {
            cells.append(.review(latest))
            cells.append(.review(highest))
            cells.append(.review(lowest))
            cells.append(.showAllReviews)
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EditUserSegue" {
//            if let vc = segue.destination as? AddEditUserViewController
//            {
//                vc.scenario = .edit
//                vc.user = user
//            }
//        }
//    }
    
    private func confirmAndDeleteUser() {
//        let confirmAlert = UIAlertController(title: Lingo.commonConfirmDelete, message: Lingo.userDetailsDeleteConfirmation, preferredStyle: .alert)
//
//        confirmAlert.addAction(UIAlertAction(title: Lingo.commonDelete, style: .destructive, handler: { [weak self] _ in
//            Task {
//                let result = await self?.viewModel.deleteUser(self?.user)
//                switch result {
//                case .success:
//                    self?.deleteCompletion?()
//                    self?.navigationController?.popViewController(animated: true)
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self?.presentErrorAlert(message: error.localizedDescription)
//                    }
//                case .none:
//                    break
//                }
//            }
//        }))
//
//        confirmAlert.addAction(UIAlertAction(title: Lingo.commonCancel, style: .cancel))
//
//        present(confirmAlert, animated: true)
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default))
        self.present(alert, animated: true)
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
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantHeaderCell.defaultReuseIdentifier, for: indexPath) as! RestaurantHeaderCell
            return cell
//        case .delete:
//            let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryButtonCell.defaultReuseIdentifier, for: indexPath) as! SecondaryButtonCell
//            cell.configure(withTitle: Lingo.commonDelete) { [weak self] in
//                self?.confirmAndDeleteUser()
//            }
//            cell.button.setTitleColor(.red, for: .normal)
//            return cell
        }
    }
}
