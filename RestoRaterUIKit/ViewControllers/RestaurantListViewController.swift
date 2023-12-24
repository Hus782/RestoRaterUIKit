//
//  RestaurantListViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import UIKit

class RestaurantListVIewController: UITableViewController {
    private var viewModel = RestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: RestaurantTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: RestaurantTableViewCell.defaultReuseIdentifier)
        
        //        bindViewModel()
        
    }
}

extension RestaurantListVIewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        let restaurant = viewModel.restaurants.value[indexPath.row]
        cell.configure(image: UIImage(named: "defaultImage") ?? UIImage(), // Replace with actual image logic
                       name: restaurant.name,
                       address: restaurant.address)
        return cell
    }
}
