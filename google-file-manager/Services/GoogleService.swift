//
//  GoogleService.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 09.06.2022.
//

import Foundation
import GoogleSignIn

class GoogleService: NSObject {
    
    static var accessToken: String = ""
    // TODO: Replace this with your own ID.
    private let clientID = "693002193153-1fon2m009ejdl1nr0hsk3918dvnv7kh5.apps.googleusercontent.com"
    
    private lazy var configuration: GIDConfiguration = {
        return GIDConfiguration(clientID: clientID)
      }()
    
    private var authViewModel: AuthenticationViewModel

      /// Creates an instance of this authenticator.
      /// - parameter authViewModel: The view model this authenticator will set logged in status on.
      init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
      }
    
    func setAccessToken() {
        guard let accessToken = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken else { return }
        GoogleService.accessToken = accessToken
    }
    
    func signIn(completion: @escaping() -> (Void)) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("There is no root view controller!")
            return
        }
        
        DispatchQueue.main.async {
            
            //self.addSpreadsheetsScope()
            
            GIDSignIn.sharedInstance.signIn(with: self.configuration,
                                            presenting: rootViewController) { user, error in
                guard let user = user else {
                    print("Error! \(String(describing: error))")
                    return
                }
                self.authViewModel.state = .signedIn(user)
                self.setAccessToken()
                self.addSpreadsheetsScope(completion: completion)
                //completion()
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        authViewModel.state = .signedOut
        GoogleService.accessToken = ""
    }
    
    /// Disconnects the previously granted scope and signs the user out.
      func disconnect() {
        GIDSignIn.sharedInstance.disconnect { error in
          if let error = error {
            print("Encountered error disconnecting scope: \(error).")
          }
          self.signOut()
        }
      }
    
      /// Adds the spreadsheets scope for the current user.
      /// - parameter completion: An escaping closure that is called upon successful completion of the
      /// `addScopes(_:presenting:)` request.
      /// - note: Successful requests will update the `authViewModel.state` with a new current user that
      /// has the granted scope.
    func addSpreadsheetsScope(completion: @escaping () -> Void) { 
        
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            fatalError("No root view controller!")
        }
        
        var scopes: [String] = []
        
//        scopes.append("https://www.googleapis.com/auth/drive")
//        scopes.append("https://www.googleapis.com/auth/drive.file")
        scopes.append("https://www.googleapis.com/auth/spreadsheets")
        
//        scopes.append("https://www.googleapis.com/auth/drive")
//        scopes.append("https://www.googleapis.com/auth/drive.file")
//        scopes.append("https://www.googleapis.com/auth/drive.resource")
//        scopes.append("https://www.googleapis.com/auth/spreadsheets")
//        scopes.append("https://spreadsheets.google.com/feeds")
//        scopes.append("https://spreadsheets.google.com/feeds/spreadsheets")
//        scopes.append("https://spreadsheets.google.com/feeds/spreadsheets/private/full")
//        scopes.append("https://spreadsheets.google.com/feeds/worksheets/")
//        scopes.append("https://spreadsheets.google.com/tq")
//        scopes.append("https://spreadsheets.google.com/feeds/list/")
//        scopes.append("https://spreadsheets.google.com/feeds")
//        scopes.append("https://spreadsheets.google.com/feeds/cell/")
        
        GIDSignIn.sharedInstance.addScopes(scopes, presenting: rootViewController) { user, error in
            if let error = error {
                print("Found error while adding spreadsheets read scope: \(error).")
                return
            }
            
            guard let currentUser = user else { return }
            self.authViewModel.state = .signedIn(currentUser)
            completion()
        }
    }
//    func restorePreviousSignIn() {
//        guard !GIDSignIn.sharedInstance.hasPreviousSignIn() else {
//            GIDSignIn.sharedInstance.restorePreviousSignIn()
//            return
//        }
//    }
//
//    func setPresentingViewController(_ vc: UIViewController) {
//        GIDSignIn.sharedInstance.presentingViewController = vc
//    }
//
//    func setDelegate() {
//        GIDSignIn.sharedInstance.delegate = self
//    }
//
//    func setScopes(scopes: [String]) {
//        GIDSignIn.sharedInstance.scopes = scopes
//    }
//
//
//
//    func setClientID(withID id: String) {
//        GIDSignIn.sharedInstance.clientID = id
//    }

    func handle(url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

//extension GoogleService: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("New or signed out user")
//            } else {
//                print(error.localizedDescription)
//            }
//            return
//        }
//        self.setAccessToken()
//
//        let vc = DriveViewController.initFromNib()
//        DispatchQueue.main.async {
//            UIApplication.shared.keyWindow?
//                .rootViewController = UINavigationController(rootViewController: vc)
//        }
//    }
//}
