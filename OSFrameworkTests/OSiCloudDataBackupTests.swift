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




    func testExample() {
        manager?.startUp()

    }
}
