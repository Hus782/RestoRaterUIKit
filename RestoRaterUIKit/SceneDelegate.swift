//
//  SceneDelegate.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        PersistenceController.shared.populateInitialDataIfNeeded()
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let root = setRootViewController()
            window.rootViewController = root
            self.window = window
            window.makeKeyAndVisible()
        }

        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func setRootViewController() -> UIViewController {
        guard let user = UserManager.shared.currentUser else {
            let loginViewController = createLoginViewController()
                return loginViewController
        }
        
        let tabBarController = TabBarController(isAdmin: user.isAdmin)
        return tabBarController
    }

    private func createLoginViewController() -> UIViewController {
        let loginViewController = LoginVIewController.instantiateFromAppStoryboard(appStoryboard: .Main)
        let navigationController = UINavigationController(rootViewController: loginViewController)
            return navigationController
    }
    
    func switchRootViewController(to viewController: UIViewController, animated: Bool = true) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate else {
                return
            }
            
            delegate.window?.rootViewController = viewController
            if animated {
                UIView.transition(with: delegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {})
            }
        }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

