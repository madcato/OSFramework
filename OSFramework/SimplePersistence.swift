//
//  SimplePersistence.swift
//  OSFramework
//
//  Created by Daniel Vela on 06/02/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

// Simple persistence class to store and read simple data
// as Strings, Bools and Ints
// Suitable to store Settings
public class SimplePersistence {
    public static var provider: SimplePersistence = {
       return UserDefaultsSimpleProvider()
    }()
    
    public static func store(_ value: String?, forKey:String) {
        provider.store(value: value, forKey: forKey)
    }
    
    func store(value: String?, forKey:String) {
    }
    
    public static func store(_ value: Bool, forKey:String) {
        provider.store(value: value, forKey: forKey)
    }
    
    func store(value: Bool, forKey:String) {
    }
    
    public static func string(forKey:String) -> String? {
        return provider.string(forKey: forKey)
    }
    
    func string(forKey:String) -> String? {
        return nil
    }
    
    public static func bool(forKey:String) -> Bool {
        return provider.bool(forKey: forKey)
    }
    
    func bool(forKey:String) -> Bool {
        return false
    }
}

// Simple class for storing data in UserDefaults on iOS
class UserDefaultsSimpleProvider: SimplePersistence {
    override func store(value: String?, forKey:String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    override func store(value: Bool, forKey:String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    override func string(forKey:String) -> String? {
        return UserDefaults.standard.string(forKey: forKey)
    }
    
    override func bool(forKey:String) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey)
    }
    
    
}
