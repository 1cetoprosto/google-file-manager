//
//  FilesItemViewModelTests.swift
//  google-file-managerTests
//
//  Created by Леонід Квіт on 15.06.2022.
//

import XCTest
@testable import google_file_manager

class FilesItemViewModelTests: XCTestCase {

    var filesItemViewModel: FilesItemViewModel?
    var filesModel: FilesModel?
    
    override func setUp() {
        super.setUp()
        filesModel = FilesModel(json: ["Foo","Bar","Baz","Foo"])
        filesItemViewModel = FilesItemViewModel(file: filesModel!)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitFilesItemViewModelWithFilesModel() throws {
        XCTAssertNotNil(filesItemViewModel)
    }
    
    func testWhenGivenValueSet() {
        XCTAssertEqual(filesItemViewModel?.file, filesModel)
        XCTAssertEqual(filesItemViewModel?.name, filesModel?.itemName)
        XCTAssertEqual(filesItemViewModel?.type, filesModel?.itemType)
    }
}
