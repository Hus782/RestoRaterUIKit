//
//  AlertHelper.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

struct AlertHelper {
    
    static func presentErrorAlert(on viewController: UIViewController,
                                  message: String,
                                  title: String = Lingo.commonError,
                                  completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: Lingo.commonOk, style: .default) { _ in
                completion?()
            }
            
            alert.addAction(okAction)
            viewController.present(alert, animated: true)
        }
    }
    
}
