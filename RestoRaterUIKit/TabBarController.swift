//
//  TabBarController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let isAdmin: Bool
    private var availableViewControllers: [UIViewController] = []
    
    init(isAdmin: Bool) {
        self.isAdmin = isAdmin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let restaurantsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListVIewController")
        let restaurantsNavigationController = createNavController(for: restaurantsViewController, title: "Restaurants", image: "fork.knife")

        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVIewController")
        let profileNavigationController = createNavController(for: profileViewController, title: "Profile", image: "person.fill")

        availableViewControllers.append(restaurantsNavigationController)
        availableViewControllers.append(profileNavigationController)

        if isAdmin {
            let usersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserListVIewController")
            let usersNavigationController = createNavController(for: usersViewController, title: "Users", image: "person.3.fill")
            availableViewControllers.insert(usersNavigationController, at: 1)
        }

        self.viewControllers = availableViewControllers
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: image)
        return navigationController
    }
}
