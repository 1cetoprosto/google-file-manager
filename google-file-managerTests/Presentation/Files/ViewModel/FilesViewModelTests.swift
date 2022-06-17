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
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}
