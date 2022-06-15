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
    //private var networkService: NetworkService!
    private var parent: String?
    private var files: [FilesModel]? // Results<FilesModel>!
    var isFolder: Bool = true
    
    
//    init(parent: String) {
//        self.parent = parent
//    }
    
    func getFiles(completion: @escaping () -> ()) {
        
        let networkService = NetworkService()
        
        networkService.getFiles { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let filesArray):
                    
                    guard var files = filesArray else { return }

                    files = files.filter { $0.itemParentUUID == self.parent ?? "" }
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