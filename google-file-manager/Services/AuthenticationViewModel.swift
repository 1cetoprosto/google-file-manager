//
//  AuthenticationViewModel.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 09.06.2022.
//

import UIKit
import GoogleSignIn

/// A class conforming to `ObservableObject` used to represent a user's authentication status.
final class AuthenticationViewModel: ObservableObject {
    /// The user's log in status.
    /// - note: This will publish updates when its value changes.
    @Published var state: State
    private var authenticator: GoogleService {
        return GoogleService(authViewModel: self)
    }
    /// The user-authorized scopes.
    /// - note: If the user is logged out, then this will default to empty.
    var authorizedScopes: [String] {
        switch state {
        case .signedIn(let user):
            return user.grantedScopes ?? []
        case .signedOut:
            return []
        }
    }
    
    /// Creates an instance of this view model.
    init() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            self.state = .signedIn(user)
        } else {
            self.state = .signedOut
        }
    }
    
    /// Signs the user in.
    func signIn(completion: @escaping() -> (Void)) {
        self.authenticator.signIn {
            completion()
        }
        
    }
    
    /// Signs the user out.
    func signOut() {
        authenticator.signOut()
    }
    
    /// Disconnects the previously granted scope and logs the user out.
    func disconnect() {
        authenticator.disconnect()
    }
}

extension AuthenticationViewModel {
    /// An enumeration representing logged in status.
    enum State {
        /// The user is logged in and is the associated value of this case.
        case signedIn(GIDGoogleUser)
        /// The user is logged out.
        case signedOut
    }
}
