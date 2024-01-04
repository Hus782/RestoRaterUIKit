//
//  UIViewController.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/4/24.
//

import UIKit

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
