//
//  FilesViewControllerTests.swift
//  google-file-managerTests
//
//  Created by Леонід Квіт on 16.06.2022.
//

import XCTest
@testable import google_file_manager

class FilesViewControllerTests: XCTestCase {
    
    var sut: FilesViewController!
    
    
    override func setUp() {
        super.setUp()
        
        sut = FilesViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testTableViewNotNilWhenViewIsLoaded() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testCollectionViewNotNilWhenViewIsLoaded() {
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testViewModelNotNilWhenViewIsLoaded() {
        XCTAssertNotNil(sut.viewModel)
    }
}
