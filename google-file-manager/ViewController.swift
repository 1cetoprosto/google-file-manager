//
//  ViewController.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 08.06.2022.
//

import UIKit
import GoogleSignIn

//var sheetData = [sheetDataModel]()
//var token = ""
//let sheetId = "1etiP3xd4X19gguazWnxNU8maBobvz1ADToj8wUkBZkk"

class ViewController: UIViewController {
    
    var authViewModel: AuthenticationViewModel?
    var filesArray: [FilesModel]?
    //private var networkService: NetworkService!
    
//    private var user: GIDGoogleUser? {
//        return GIDSignIn.sharedInstance.currentUser
//    }
    
//    lazy var getFilesButton: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.layer.borderWidth = 1.1
//        btn.layer.borderColor = UIColor.link.cgColor
//        btn.layer.cornerRadius = 6
//        btn.addTarget(self, action: #selector(didTapOnGetFilesButton), for: .touchUpInside)
//
//        return btn
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        //view.addSubview(getFilesButton)
        getFiles()
        
    }
    
     func getFiles() {
        let networkService = NetworkService()
        networkService.getFiles { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let filesArray):
                    self.filesArray = filesArray
                    guard let files = filesArray else {
                        return
                    }
                    for item in files {
                        print(item.itemName)
                    }
                    let root = files.filter { $0.itemParentUUID == "" }
                    for item in root {
                        print("name: \(item.itemName) - directory: \(item.itemParentUUID)")
                    }
                    //completion()
                    //self.view?.succes()
                case .failure(let error):
                    print("Error getLessons: \(error.localizedDescription)")
                    //self.view?.failure(error: error)
                }
            }
        }
        
    }
    
    func disconnect() {
        if let authViewModel = authViewModel {
            authViewModel.disconnect()
        }
    }
    
    func signOut() {
        if let authViewModel = authViewModel {
            authViewModel.signOut()
        }
    }
}

