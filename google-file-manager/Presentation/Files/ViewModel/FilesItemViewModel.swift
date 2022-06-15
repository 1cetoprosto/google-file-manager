//
//  FilesItemViewModel.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import Foundation

class FilesItemViewModel: FilesItemViewModelType {

    private(set) var file: FilesModel
    
    var name: String {
        return file.itemName
    }
    
    var type: String {
        return file.itemType
    }
    
    init(file: FilesModel) {
        self.file = file
    }
}
