//
//  Storyboards.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/4/24.
//

import UIKit

enum AppStoryboard : String {
    case Main
    case Restaurants
    case Users
    case Profile
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        return instance.instantiateViewController(withIdentifier: storyboardID) as!T
    }
    //
    func initialviewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
