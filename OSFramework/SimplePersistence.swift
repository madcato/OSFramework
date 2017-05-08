//
//  SimplePersistence.swift
//  OSFramework
//
//  Created by Daniel Vela on 06/02/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

// To store Any object implement NSCoding protocol as:

//    class SerializableWebQuery: NSObject, NSCoding {
//        var url: String
//
//        init(url: String) {
//            self.url = url
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            self.url = aDecoder.decodeObject(forKey: "url") as! String
//        }
//
//        func encode(with aCoder: NSCoder) {
//            aCoder.encode(self.url, forKey: "url")
//        }
//
//        func start(onOk: (), onError: ()) {
//
//        }
//    }

// Simple persistence class to store and read simple data
// as Strings, Bools and Ints
// Suitable to store Settings
public class SimplePersistence {
    public static var provider: SimplePersistence = {
        return UserDefaultsSimpleProvider()
    }()

    public static func store(_ value: String?,
                             forKey key: String) {
        provider.store(value: value, forKey: key)
    }

    func store(value: String?, forKey key: String) {
    }

    public static func store(_ value: Bool,
                             forKey key: String) {
        provider.store(value: value, forKey: key)
    }

    func store(value: Bool, forKey key: String) {
    }

    public static func store(_ value: [Any]?,
                             forKey key: String) {
        provider.store(value: value, forKey: key)
    }

    func store(value: [Any]?, forKey key: String) {
    }

    public static func store(_ value: Any?,
                             forKey key: String) {
        provider.store(value: value, forKey: key)
    }

    func store(value: Any?, forKey key: String) {
    }

    public static func string(forKey key: String) -> String? {
        return provider.string(forKey: key)
    }

    func string(forKey key: String) -> String? {
        return nil
    }

    public static func bool(forKey key: String) -> Bool {
        return provider.bool(forKey: key)
    }

    func bool(forKey key: String) -> Bool {
        return false
    }

    public static func array(forKey key: String) -> [Any]? {
        return provider.array(forKey: key)
    }

    func array(forKey key: String) -> [Any]? {
        return nil
    }

    public static func object(forKey key: String) -> Any? {
        return provider.object(forKey: key)
    }

    func object(forKey key: String) -> Any? {
        return nil
    }
}

// Simple class for storing data in UserDefaults on iOS
class UserDefaultsSimpleProvider: SimplePersistence {
    override func store(value: String?,
                        forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    override func store(value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    override func store(value: [Any]?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    override func store(value: Any?, forKey key: String) {
        var data: Data?
        if let value = value {
            data = NSKeyedArchiver.archivedData(withRootObject: value)
        } else {
            data = nil
        }
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }

    override func string(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    override func bool(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    override func array(forKey key: String) -> [Any]? {
        return UserDefaults.standard.array(forKey: key)
    }

    override func object(forKey key: String) -> Any? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return nil
    }
}
