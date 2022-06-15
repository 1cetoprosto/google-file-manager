//
//  SceneDelegate.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 08.06.2022.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print("app's signed-out state")
                self.window = UIWindow(windowScene: windowScene)
                self.window?.rootViewController = SignInViewController()
                self.window?.makeKeyAndVisible()
                
            } else {
                // Show the app's signed-in state.
                print("app's signed-in state")
                
                GoogleService(authViewModel: AuthenticationViewModel()).setAccessToken()
                let navigationController = UINavigationController()
                navigationController.viewControllers = [FilesViewController()]
                self.window = UIWindow(windowScene: windowScene)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
    }
}

