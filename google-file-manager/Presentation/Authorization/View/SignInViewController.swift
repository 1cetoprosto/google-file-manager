//
//  SignInViewController.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 09.06.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    lazy var googleSignInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.layer.borderWidth = 1.1
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.cornerRadius = 6
        //button.backgroundColor = .systemBlue
        //button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var googleSignOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let googleService = GoogleService(authViewModel: AuthenticationViewModel())

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Authorization"
        view.backgroundColor = .white
        //navigationController?.view.backgroundColor = .systemBlue
        
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
        
        let buttonStackView = UIStackView(arrangedSubviews: [googleSignInButton, googleSignOutButton])
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
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
