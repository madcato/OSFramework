//
//  OSiCloudDataBackup.swift
//  OSFramework
//
//  Created by Daniel Vela on 20/09/2016.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

/**
 Delegate of class OSiCloudDataBackup. Methods are called to indicate a 
 change of the state of the class or to indicate some error.
 - Author Daniel Vela
*/
public protocol OSiCloudDataBackupDelegate: class {
    /** 
     Called when the state is changed.
     - Parameter manager: object that fires this method who had changed the state
     */
    func didUpdateState(manager: OSiCloudDataBackup)
}

/**
 This class manages the backup of some data to iCloud. 
 It indicates if there is data or not and the date of the stored data.
 - Author Daniel Vela
*/
public class OSiCloudDataBackup: NSObject {

    /**
     State of the OSiCloudDataBackup object.
     
        - unknown: initial state
        - iCloudNotAllowed: when app is not allowed to access iCloud or the user has not activated it
        - iCloudAllowed: if tha app has access to iCloud
        - dataAvailable: if iCloud is allowed, then is checked if data is available.
        - error: if an error occurred
     */
    public enum OSiCloudDataBackupState {
        case unknown
        case iCloudNotAllowed
        case iCloudAllowed
        case dataAvailable
        case error(errorDescription: String)
    }

    private var dataKey = "OSiCloudDataBackupData"
    private var dateKey = "OSiCloudDataBackupDate"
    
    /** 
     State of the object
        - SeeAlso OSiCloudDataBackupState

    */
    public var state: OSiCloudDataBackupState = .unknown

    /**
     Backup data. This property obly has value after calling **load** method.
     */
    public var storedData: Data?

    /**
     Date of store of the data if exists.
     This property obly has value after calling **load** method.
    */
    public var storeDate: Date?

    /** 
     Delegate objcet
    */
    public weak var delegate: OSiCloudDataBackupDelegate?

    /**
     Initialization. Delegate is mandatory.
    */
    public init(delegate: OSiCloudDataBackupDelegate) {
        self.delegate = delegate
    }

    /**
     Start the execution of the process. Checks if iCloud is enabled and allowed.
     Also checks if data is available.
    */
    public func startUp() {
        check()
    }

    /**
     Store data in iCloud. Also stores the current date. The data is stored in
     the property called "OSiCloudDataBackupData". The date is stored in the
     property called "OSiCloudDataBackupDate".
     
     If occurs an error, the state of this object changes to **error**.
     
     - Important data length must not exceed 1MB
    */
    public func store(data: Data) {
        self.writeObject(object: data, forKey: dataKey)
        self.writeObject(object: Date(), forKey: dateKey)
    }

    /**
     Load the data stored in iCloud

     - Precondition state must be **dataAvailable**

     - Returns: The loaded content
    */
    private func load() {
        storedData = object(key: dataKey) as? Data
        storeDate = object(key: dateKey) as? Date
        
        if storedData != nil {
            state = .dataAvailable
            delegate?.didUpdateState(manager: self)
        }
    }

    private func configureChangeNotification() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(OSiCloudDataBackup.iCloudValueChanged(notification:)),
                           name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                           object: NSUbiquitousKeyValueStore.default())

        // get changes that might have happened while this
        // instance of your app wasn't running
        NSUbiquitousKeyValueStore.default().synchronize()
    }

    @objc func iCloudValueChanged(notification: Notification) {
        check()
    }

    /**
     Checks state of iCloud and reads all the data if available
    */
    private func check() {
        if isiCloudContainerAvailable() {
            state = .iCloudAllowed
        } else {
            state = .iCloudNotAllowed
        }
        delegate?.didUpdateState(manager: self)

        load()
    }
    /**
     Reads an object from  ubiquity container

     - Parameter key: key of the value to retrive

     - Returns: the object
    */
    private func object(key: String) -> Any? {
        let iCloudStore = NSUbiquitousKeyValueStore.default()
        let value = iCloudStore.object(forKey: key)
        return value
    }

    /**
     Writes an object to ubiquity container

     - Parameter object: object to store
     - Parameter key: key of the value to retrive
     */
    private func writeObject(object: Any, forKey key: String) {
        let iCloudStore = NSUbiquitousKeyValueStore.default()
        iCloudStore.set(object, forKey: key)
        iCloudStore.synchronize()
    }

    private func isiCloudContainerAvailable()->Bool {
        if let _ = FileManager.default.ubiquityIdentityToken {
            return true
        }
        else {
            return false
        }
    }
}
