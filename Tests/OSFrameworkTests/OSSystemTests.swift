//
//  OSSystemTests.swift
//  OSFrameworkTests
//
//  Created by Daniel Vela on 30/01/2018.
//  Copyright © 2018 Daniel Vela. All rights reserved.
//

import XCTest
@testable import OSFramework

class OSSystemTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUUID() {
        let uuid = OSSystem.generateUUID()
        XCTAssertNotNil(uuid)
    }

}
