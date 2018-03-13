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

    static let testQueue = DispatchQueue(label: "com.ATMockHttpClient.test")

    func startGetRequest(withURL url: String,
                         complete: @escaping (HttpRequestResult) -> Void) {
        ATMockHttpClient.testQueue.async {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let localUrl = documentDirectory?.appendingPathComponent("data.json")
            let data = try? Data(contentsOf: localUrl!)
            complete(.success(data))
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
