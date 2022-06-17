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
    
    init(name: String, type: String, parentUuid: String = "") {
        self.itemName = name
        self.itemType = type
        self.itemParentUUID = parentUuid
        self.itemUUID = UUID().uuidString
    }
    
    init () {}
}

extension FilesModel: Equatable {
    static func == (lhs: FilesModel, rhs: FilesModel) -> Bool {
        guard lhs.itemUUID == rhs.itemUUID &&
                lhs.itemParentUUID == rhs.itemParentUUID &&
                lhs.itemType == rhs.itemType &&
                lhs.itemName == rhs.itemName
        else { return false }
        return true
    }
}

// MARK: - GoogleSheet
struct GoogleSheet: Codable {
    let range, majorDimension: String
    let values: [[String]]
}

// MARK: - UpdatedGoogleSheet
struct UpdatedGoogleSheet: Codable {
    let spreadsheetID: String
    let totalUpdatedRows, totalUpdatedColumns, totalUpdatedCells, totalUpdatedSheets: Int
    let responses: [Response]

    enum CodingKeys: String, CodingKey {
        case spreadsheetID = "spreadsheetId"
        case totalUpdatedRows, totalUpdatedColumns, totalUpdatedCells, totalUpdatedSheets, responses
    }
}

// MARK: - Response
struct Response: Codable {
    let spreadsheetID, updatedRange: String
    let updatedRows, updatedColumns, updatedCells: Int

    enum CodingKeys: String, CodingKey {
        case spreadsheetID = "spreadsheetId"
        case updatedRange, updatedRows, updatedColumns, updatedCells
    }
}

var filesArray: [FilesModel] = []
