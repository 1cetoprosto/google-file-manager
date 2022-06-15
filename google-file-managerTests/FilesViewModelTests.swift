//
//  FilesViewModelTests.swift
//  google-file-managerTests
//
//  Created by Леонід Квіт on 15.06.2022.
//

import XCTest
@testable import google_file_manager

class FilesViewModelTests: XCTestCase {
    var sut: FilesViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FilesViewModel()
        //sut.files = [FilesModel(json: ["One","Two"])]
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testFilesModelShouldBeNotNil() throws {
        //sut.numberOfRowInSection(for: -1)
//        sut.getFiles {
//            
//        }
//        let files = sut.files
//        
//        XCTAssertNotNil(files, "FilesModel should be not nil") 
        
    }

}
