//
//  ViewControllerHelper.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

struct ViewControllerHelper {
    
    static func presentErrorAlert(on viewController: UIViewController, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Lingo.commonError, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Lingo.commonOk, style: .default))
            viewController.present(alert, animated: true)
        }
    }
    
}
