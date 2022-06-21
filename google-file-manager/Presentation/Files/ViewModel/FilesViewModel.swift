//
//  FilesViewModel.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import Foundation
import UIKit

class FilesViewModel: FilesViewModelType {

    private var selectedIndexPath: IndexPath?
    var parent: String?
    private(set) var files: [FilesModel]?
    private(set) var allFiles: [FilesModel]?
    var isFolder: Bool = true
    
    func getFiles(completion: @escaping () -> ()) {
        
        let networkService = NetworkService(session: URLSession.shared)
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId)/values/Sheet1!A1:D" //1000
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        networkService.getFiles(url: url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let filesArray):
                    
                    guard var files = filesArray else { return }
                    self.allFiles = files
                    files = files.filter { $0.itemParentUUID == self.parent ?? "" }
                    files = files.filter { $0.itemUUID != "" }
                    files = files.sorted {
                        if $0.itemType != $1.itemType {
                            return $0.itemType < $1.itemType
                        } else {
                            return $0.itemName < $1.itemName
                        }
                    }
                    self.files = files
                    completion()
                    //self.view?.succes()
                case .failure(let error):
                    print("Error getFiles: \(error.localizedDescription)")
                    //self.view?.failure(error: error)
                }
            }
        }
    }
    
    func updateFiles(entry: FilesModel, completion: @escaping () -> ()) {
        guard let countFiles = files?.count else { return }
        let range = "Sheet1!A\(countFiles + 1):D\(countFiles + 1)"
        let parameters = ["valueInputOption": "USER_ENTERED", "data": [["majorDimension": "Rows", "range": "\(range)", "values":[[entry.itemUUID, entry.itemParentUUID, entry.itemType, entry.itemName]]]]] as [String : Any]
        
        let networkService = NetworkService(session: URLSession.shared)
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId)/values:batchUpdate"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        networkService.updateFiles(url: url, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let updated):
                    if updated {
                        self.files?.append(entry)
                        completion()
                    }
                case .failure(let error):
                    print("Error getFiles: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteFiles() { //index: Int,
        
        guard let selectedIndexPath = selectedIndexPath,
              let files = self.files else { return }
        
        let file = files[selectedIndexPath.row]
        
        guard let delIndex = allFiles?.firstIndex(of: file) else { return }
        //print("Found peaches at index \(delIndex)")
        let range = "Sheet1!A\(delIndex + 1):D\(delIndex + 1)"

        let networkService = NetworkService(session: URLSession.shared)

        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId)/values/\(range):clear"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        networkService.deleteFiles(url: url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let deleted):
                    if deleted {
                        //self.files?.remove(at: selectedIndexPath.row)
                        //completion()
                        //self.getFiles(completion: completion)
                    }
                case .failure(let error):
                    print("Error deleteFiles: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func numberOfRowInSection(for section: Int) -> Int {
        guard let files = self.files else { return 0 }
        
        return files.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> FilesItemViewModelType? {
        guard let files = self.files else { return nil }
        let file = files[indexPath.row]
        return FilesItemViewModel(file: file)
    }
    
    func viewModelForSelectedRow() -> FilesViewModelType? {
        guard let selectedIndexPath = selectedIndexPath,
              let files = self.files else { return nil }
        
        let file = files[selectedIndexPath.row]
        let viewModel = FilesViewModel()
        viewModel.parent = file.itemUUID
        
        return viewModel
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        guard let selectedIndexPath = selectedIndexPath,
              let files = self.files else { return }
        let file = files[selectedIndexPath.row]
        self.isFolder = file.itemType == "d"
        self.parent = file.itemUUID
    }
    
}
