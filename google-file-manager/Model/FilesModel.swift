//
//  FilesModel.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 11.06.2022.
//

import Foundation

struct FilesModel: Codable {
    var itemUUID = ""
    var itemParentUUID = ""
    var itemType = ""
    var itemName = ""
    
    init(json: [String]) {
        if json.count >= 4 {
            self.itemUUID = json[0].description
            self.itemParentUUID = json[1].description
            self.itemType = json[2].description
            self.itemName = json[3].description
        }
    }
}

// MARK: - GoogleSheet
struct GoogleSheet: Codable {
    let range, majorDimension: String
    let values: [[String]]
}

var filesArray: [FilesModel] = []
