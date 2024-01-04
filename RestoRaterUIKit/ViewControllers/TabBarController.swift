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
        let restaurantsViewController = RestaurantListVIewController.instantiateFromAppStoryboard(appStoryboard: .Restaurants)
        
        let restaurantsNavigationController = createNavController(for: restaurantsViewController, title: Lingo.restaurantTab, image: Constants.restaurantsTabImage)

        let profileViewController = ProfileVIewController.instantiateFromAppStoryboard(appStoryboard: .Profile)
        let profileNavigationController = createNavController(for: profileViewController, title: Lingo.profileTab, image: Constants.profileTabImage)

        availableViewControllers.append(restaurantsNavigationController)
        availableViewControllers.append(profileNavigationController)

        if isAdmin {
            let usersViewController = UserListVIewController.instantiateFromAppStoryboard(appStoryboard: .Users)
            let usersNavigationController = createNavController(for: usersViewController, title: Lingo.usersTab, image: Constants.usersTabImage)
            availableViewControllers.insert(usersNavigationController, at: 1)
        }

        self.viewControllers = availableViewControllers
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
