//
//  FilesModelTests.swift
//  google-file-managerTests
//
//  Created by Леонід Квіт on 15.06.2022.
//

import XCTest
@testable import google_file_manager

class FilesModelTests: XCTestCase {

    var json = [String]()
    var filesModel: FilesModel?
    
    
    override func setUp()  {
        super.setUp()
        json = ["Foo","Bar","Baz","Foo"]
        filesModel = FilesModel(json: json)
    }

    override func tearDown()  {
        super.tearDown()
        json = []
        filesModel = nil
    }

    func testInitFilesModelWithJSON() throws {
        XCTAssertNotNil(filesModel, "FilesModel should be not nil")
    }
    
    func testCountOfJsonArrayEqual4() {
        XCTAssertGreaterThanOrEqual(json.count, 4, "Count of JSON array should be greater than or equal 4")
    }
    
    func testWhenGivenValueSet() {
        XCTAssertEqual(filesModel?.itemUUID, "Foo")
        XCTAssertEqual(filesModel?.itemParentUUID, "Bar")
        XCTAssertEqual(filesModel?.itemType, "Baz")
        XCTAssertEqual(filesModel?.itemName, "Foo")
    }
}
