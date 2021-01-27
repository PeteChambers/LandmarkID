//
//  LandmarkIDSlowTests.swift
//  LandmarkIDSlowTests
//
//  Created by Peter Chambers on 27/01/2021.
//  Copyright © 2021 Pete Chambers. All rights reserved.
//

import XCTest
@testable import Landmark_ID

class LandmarkIDSlowTests: XCTestCase {

    var sut: URLSession!

    override func setUp() {
      super.setUp()
      sut = URLSession(configuration: .default)
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    func testValidCallToWikipediaGetsHTTPStatusCode200() {
        
        let testArticle = "dog"
        
        let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(testArticle)")

        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }
    
    func testCallToWikipeidaCompletes() {
        
        let testArticle = "dog"
        let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(testArticle)")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
