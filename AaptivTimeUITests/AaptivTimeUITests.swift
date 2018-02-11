//
//  AaptivTimeUITests.swift
//  AaptivTimeUITests
//
//  Created by HAO WANG on 2/6/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import XCTest

class AaptivTimeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInfiniteScrollIsThere() {

        let infiniteScroll = XCUIApplication().scrollViews["ArticleSectionInfiniteScroll"]
        XCTAssertTrue(infiniteScroll.exists)
    }
}
