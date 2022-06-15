//
//  SignInViewController.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 09.06.2022.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {
    
    lazy var googleSignInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.Button.title, for: .normal)
        button.layer.borderWidth = 1.1
        button.layer.borderColor = UIColor.Button.border.cgColor
        button.layer.cornerRadius = 6
        //button.backgroundColor = UIColor.Button.background
        //button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var googleSignOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.Button.title, for: .normal)
        button.layer.borderWidth = 1.1
        button.layer.borderColor = UIColor.Button.border.cgColor
        button.layer.cornerRadius = 6
        //button.backgroundColor = UIColor.Button.background
        //button.layer.masksToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var userName: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.Main.text
        lbl.text = "user test"
        
        return lbl
    }()
    
    private let googleService = GoogleService(authViewModel: AuthenticationViewModel())

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Authorization"
        view.backgroundColor = UIColor.Main.background
        navigationController?.view.backgroundColor = .systemBlue
        
        //let user = GIDSignIn.sharedInstance.currentUser
        userName.text = GIDSignIn.sharedInstance.currentUser?.profile?.name
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        switchButtons()
    }
    
    private func switchButtons() {
        if !GoogleService.accessToken.isEmpty {
            googleSignInButton.isHidden = true
            googleSignOutButton.isHidden = false
        } else {
            googleSignInButton.isHidden = false
            googleSignOutButton.isHidden = true
        }
        //let user = GIDSignIn.sharedInstance.currentUser?.profile?.name
        userName.text = GIDSignIn.sharedInstance.currentUser?.profile?.name
    }
}

extension SignInViewController {
    @objc func signInButtonTapped(_ sender: Any?) {
        
        googleService.signIn { [weak self] in
            if !GoogleService.accessToken.isEmpty {
                self?.navigationController?.pushViewController(FilesViewController(), animated: true)
            }
        }
        
//        googleService.addSpreadsheetsScope { [weak self] in
//            if !GoogleService.accessToken.isEmpty {
//                self?.navigationController?.pushViewController(ViewController(), animated: true)
//            }
//        }
    }
    
    @objc func signOutButtonTapped(_ sender: Any?) {
        googleService.signOut()
        switchButtons()
    }
}

// MARK: - Constraints
extension SignInViewController {
    func setConstraints() {
        
//        view.addSubview(userName)
//        NSLayoutConstraint.activate([
//            userName.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 25),
//            userName.bottomAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0),
//            userName.widthAnchor.constraint(equalToConstant: 250),
//            userName.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        let buttonStackView = UIStackView(arrangedSubviews: [userName, googleSignInButton, googleSignOutButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        
        view.addSubview(buttonStackView)
        
//        NSLayoutConstraint.activate([
//            buttonStackView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -20),
//            buttonStackView.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 20),
//            buttonStackView.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -20),
//            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 150),
            buttonStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
