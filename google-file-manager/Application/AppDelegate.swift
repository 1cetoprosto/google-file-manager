//
//  AppDelegate.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 08.06.2022.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    private let id = "453999149277-hg97ils5re9m581naqf6ic8ihnjm6r9k.apps.googleusercontent.com"
//    private let googleService = GoogleService(authViewModel: AuthenticationViewModel())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GoogleService(authViewModel: AuthenticationViewModel()).handle(url: url)
    }
}

