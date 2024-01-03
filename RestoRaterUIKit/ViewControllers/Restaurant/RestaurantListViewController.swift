//
//  RestaurantListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import UIKit

final class RestaurantListVIewController: UITableViewController {
    private let viewModel = RestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadRestaurants()
        setupAddButton()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: RestaurantTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RestaurantTableViewCell.defaultReuseIdentifier)
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRestaurantAction))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addRestaurantAction() {
        performSegue(withIdentifier: "AddRestaurantSegue", sender: self)
    }
    
    private func loadRestaurants() {
        Task {
            await viewModel.fetchRestaurants()
            tableView.reloadData()
        }
    }
    
    private func reloadData() {
        self.loadRestaurants()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantDetailsSegue" {
            if let userDetailsVC = segue.destination as? RestaurantDetailsViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedRestaurant = viewModel.restaurants.value[indexPath.row]
                userDetailsVC.restaurant = selectedRestaurant
                userDetailsVC.hidesBottomBarWhenPushed = true
                userDetailsVC.deleteCompletion = { [weak self] in
                    self?.reloadData()
                }
            }
        } else if segue.identifier == "AddRestaurantSegue" {
            if let vc = segue.destination as? AddEditRestaurantViewController
            {
                vc.scenario = .add
                vc.completion = { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.reloadData()
                }
            }
        }
    }
}

extension RestaurantListVIewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.defaultReuseIdentifier, for: indexPath) as! RestaurantTableViewCell
        let restaurant = viewModel.restaurants.value[indexPath.row]
        cell.configure(image: UIImage(data: restaurant.image) ?? UIImage(),
                       name: restaurant.name,
                       address: restaurant.address)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RestaurantDetailsSegue", sender: indexPath)
    }
}
