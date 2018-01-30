//
//  OSSystem.swift
//  OSLibrary
//
//  Created by Daniel Vela on 08/08/16.
//  Copyright © 2016 veladan. All rights reserved.
//

import UIKit

public class OSSystem {
    // When the mobile detects something near the display, turn off it
    public static func enableProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    // Disable proximity sensor
    public static func disableProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }

    public static func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }

    public static func getDateFormatCurrentLocale(dateComponents: String) -> String? {
        let locale = NSLocale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: dateComponents,
                                                  options: 0,
                                                  locale: locale)
        return dateFormat
    }

    public static func disableIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    public static func loadDictionaryFromResource(fileName: String) -> NSMutableDictionary? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            return nil
        }
        let plist = NSMutableDictionary(contentsOfFile: path)
        return plist
    }

    public static func loadArrayFromResource(fileName: String) -> NSMutableArray? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            return nil
        }
        let plist = NSMutableArray(contentsOfFile: path)
        return plist
    }

    public static func redrawView(view: UIView) {
        view.setNeedsDisplay()
    }

    public static func existObjectInConfiguration(_ objectName: String) -> Bool {
        guard UserDefaults.standard.object(forKey: objectName) != nil else {
            return false
        }
        return true
    }

    public static func createObjectInConfiguration(_ object: Any?, forKey objectName: String) {
        UserDefaults.standard.set(object, forKey: objectName)
        UserDefaults.standard.synchronize()
    }

    public static func loadFromConfig(_ objectName: String) -> Any? {
        return UserDefaults.standard.object(forKey: objectName)
    }

    public static func getPreferredLanguage() -> String? {
        return NSLocale.current.languageCode
    }

    public static func batteryLevel() -> Float {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let level = device.batteryLevel
        device.isBatteryMonitoringEnabled = false
        return level
    }

    public static func screenBright() -> CGFloat {
        return UIScreen.main.brightness
    }

    public static func setScreenBright(_ bright: CGFloat) {
        UIScreen.main.brightness = bright
    }

    public static func registerUserDefaults() {
        guard let settingsBundle = Bundle.main.path(forResource: "Settings",
                                       ofType: "bundle") else {
            NSLog("Could not find Settings.bundle")
            return
        }
        let settings = NSDictionary(contentsOfFile: settingsBundle.appending("Root.plist"))
        if let preferences = settings!["PreferenceSpecifiers"] as? NSArray {
            let defaultsToRegister: [String: Any] = collectProperties(preferences)
            UserDefaults.standard.register(defaults: defaultsToRegister)
        }
    }

    public static func collectProperties(_ preferences: NSArray) -> [String: Any] {
    var defaultsToRegister: [String: Any] = [:]
        for case let prefSpecification as NSDictionary in preferences {
            if let key = prefSpecification["Key"] as? String {
                if let object = UserDefaults.standard.object(forKey: key) {
                    defaultsToRegister[key] = object
                }
            }
        }
        return defaultsToRegister
    }

    public static func generateUUID() -> String {
        let uuid = NSUUID()
        let uuidStr = uuid.uuidString
        return uuidStr
    }
}
