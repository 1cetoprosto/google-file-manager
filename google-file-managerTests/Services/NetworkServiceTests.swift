//
//  NetworkServiceTests.swift
//  google-file-managerTests
//
//  Created by Леонід Квіт on 15.06.2022.
//

import XCTest
@testable import google_file_manager

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        networkService = NetworkService(session: session)
    }
    
    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    func testGetRequestWithURL() {
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        
        networkService.getFiles(url: url) { success in
            // Return data
            
        }
        
        XCTAssert(session.lastURL == url)
    }
    
    func testGetResumeCalled() {
        
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        
        networkService.getFiles(url: url) { success in
            // Return data
        }
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
//    func testGetShouldReturnData() {
//        let expectedData = "{}".data(using: .utf8)
//        
//        session.nextData = expectedData
//        
//        var actualData: Result<[FilesModel]?, Error>?
//        print("sheetId: \(sheetId)")
//        print("accessToken: \(GoogleService.accessToken)")
//        guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId)/values/Sheet1!A1:D1000") else {
//            fatalError("URL can't be empty")
//        }
//        networkService.getFiles(url: url) { success in
//            actualData = success
//        }
//        
//        XCTAssertNotNil(actualData)
//    }
}
