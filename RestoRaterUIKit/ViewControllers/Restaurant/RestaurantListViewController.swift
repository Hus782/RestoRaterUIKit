//
//  RestaurantListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import UIKit

final class RestaurantListVIewController: UITableViewController {
    private var viewModel = RestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: RestaurantTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RestaurantTableViewCell.defaultReuseIdentifier)
        
        loadRestaurants()
        
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
        if segue.identifier == "UserDetailsSegue" {
       
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        let restaurant = viewModel.restaurants.value[indexPath.row]
        cell.configure(image: UIImage(data: restaurant.image ?? Data()) ?? UIImage(),
                       name: restaurant.name,
                       address: restaurant.address)
        return cell
    }
}
