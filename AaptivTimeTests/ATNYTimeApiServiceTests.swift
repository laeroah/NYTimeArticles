//
//  ATNYTimeApiServiceTests.swift
//  AaptivTimeTests
//
//  Created by HAO WANG on 2/7/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import XCTest
@testable import AaptivTime

class ATMockHttpClient: ATHttpClientable {
    func startGetRequest(withURL url: String,
                         complete: @escaping (Any?, Error?) -> ()) {

        DispatchQueue(label: "com.ATMockHttpClient.test").async {
            complete(["results": [["somekey": "someValue"]]], nil)
        }
    }
}

class ATNYTimeApiServiceTests: XCTestCase {

    var apiService: ATNYTimeAPIService?

    override func setUp() {
        super.setUp()
        self.apiService = ATNYTimeAPIService(httpClient: ATMockHttpClient())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchingTopStories() {
        let serviceSuccessExpectation = expectation(description: "Fetching should be successful with mocked http client")
        self.apiService?.fetchTopStories(complete: { (json, error) in

            XCTAssertNil(error, "should not return error when http client is returning json dictionary")
            serviceSuccessExpectation.fulfill()
        })
        wait(for: [serviceSuccessExpectation], timeout: 0.5)
    }
    
}
