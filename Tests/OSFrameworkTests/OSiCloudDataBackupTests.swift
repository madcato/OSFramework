//
//  OSiCloudDataBackupTests.swift
//  OSFramework
//
//  Created by Daniel Vela on 20/09/2016.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import XCTest
import OSFramework

class OSiCloudDataBackupTests: XCTestCase {

    var manager: OSiCloudDataBackup?
    var delegateMock: OSiCloudDataBackupDelegateMock?

    class OSiCloudDataBackupDelegateMock: OSiCloudDataBackupDelegate {
        func didUpdateState(manager: OSiCloudDataBackup) {
            print("Updated state", manager.state)
            switch manager.state {
            case .unknown: break
            case .iCloudNotAllowed: break
            case .iCloudAllowed: break
            case .dataAvailable: break
            case .error:
                print("Error detected")
          }
        }
    }

    override func setUp() {
        super.setUp()
        self.delegateMock = OSiCloudDataBackupDelegateMock()
        self.manager = OSiCloudDataBackup(delegate: self.delegateMock!)
    }

    override func tearDown() {
        self.manager = nil
        self.delegateMock = nil
        super.tearDown()
    }

    func testExample() {
        manager?.startUp()
    }
}
