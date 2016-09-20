//
//  OSiCloudDataBackupTests.swift
//  OSFramework
//
//  Created by Daniel Vela on 20/09/2016.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import XCTest
@testable import OSFramework

class OSiCloudDataBackupTests: XCTestCase {

    var manager: OSiCloudDataBackup?
    var delegate: OSiCloudDataBackupDelegateMock?

    class OSiCloudDataBackupDelegateMock: OSiCloudDataBackupDelegate {
        func didUpdateState(manager: OSiCloudDataBackup) {
            print("Updated state", manager.state)
            switch manager.state {
            case .unknown: break
            case .iCloudNotAllowed: break
            case .iCloudAllowed: break
            case .dataAvailable: break
            case let .error(errorDescription):
                print("Error detected", errorDescription)
                break
            }
        }
    }


    override func setUp() {
        super.setUp()
        self.delegate = OSiCloudDataBackupDelegateMock()
        self.manager = OSiCloudDataBackup(delegate: self.delegate!)
    }
    
    override func tearDown() {

        self.manager = nil
        self.delegate = nil
        
        super.tearDown()
    }




    func testAcces() {
        manager?.startUp()
    }


    class OSiCloudDataBackupDelegateToReadMock: OSiCloudDataBackupDelegateMock {
        var fail = false
        override func didUpdateState(manager: OSiCloudDataBackup) {
            super.didUpdateState(manager: manager)

            switch manager.state {
            case .dataAvailable:

                if manager.storedData == nil {
                    fail = true
                }
                if manager.storeDate == nil {
                    fail = true
                }
                default: break
            }
        }
    }
    func testWriteAndRead() {
        manager?.startUp()
        let data = "Hola Mundo".data(using: String.Encoding.utf8)
        manager?.store(data: data!)

        let delegate = OSiCloudDataBackupDelegateToReadMock()
        self.manager = OSiCloudDataBackup(delegate: delegate)
        self.manager?.startUp()

        XCTAssertFalse(delegate.fail, "Ubiquity read failed")
    }
}
