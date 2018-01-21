//
//  OSSystem.swift
//  OSLibrary
//
//  Created by Daniel Vela on 08/08/16.
//  Copyright © 2016 veladan. All rights reserved.
//

import UIKit

class OSSystem {
    // When the mobile detects something near the display, turn off it
    static func enableProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    // Disable proximity sensor
    static func disableProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }

    static func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }

    static func getDateFormatCurrentLocale(dateComponents: String) -> String? {
        let locale = NSLocale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: dateComponents,
                                                  options: 0,
                                                  locale: locale)
        return dateFormat
    }

    static func disableIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    static func loadDictionaryFromResource(fileName: String) -> NSMutableDictionary? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            return nil
        }
        let plist = NSMutableDictionary(contentsOfFile: path)
        return plist
    }

    static func loadArrayFromResource(fileName: String) -> NSMutableArray? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            return nil
        }
        let plist = NSMutableArray(contentsOfFile: path)
        return plist
    }

    static func redrawView(view: UIView) {
        view.setNeedsDisplay()
    }

    static func existObjectInConfiguration(_ objectName: String) -> Bool {
        guard UserDefaults.standard.object(forKey: objectName) != nil else {
            return false
        }
        return true
    }

    static func createObjectInConfiguration(_ object: Any?, forKey objectName: String) {
        UserDefaults.standard.set(object, forKey: objectName)
        UserDefaults.standard.synchronize()
    }

    static func loadFromConfig(_ objectName: String) -> Any? {
        return UserDefaults.standard.object(forKey: objectName)
    }

    static func getPreferredLanguage() -> String? {
        return NSLocale.current.languageCode
    }

    static func batteryLevel() -> Float {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let level = device.batteryLevel
        device.isBatteryMonitoringEnabled = false
        return level
    }

    static func screenBright() -> CGFloat {
        return UIScreen.main.brightness
    }

    static func setScreenBright(_ bright: CGFloat) {
        UIScreen.main.brightness = bright
    }

    static func registerUserDefaults() {
        guard let settingsBundle = Bundle.main.path(forResource: "Settings",
                                       ofType: "bundle") else {
            NSLog("Could not find Settings.bundle")
            return
        }
        let settings = NSDictionary(contentsOfFile: settingsBundle.appending("Root.plist"))
        if let preferences = settings!["PreferenceSpecifiers"] as? NSArray {
            var defaultsToRegister: [String: Any] = [:]
            for case let prefSpecification as NSDictionary in preferences {
                if let key = prefSpecification["Key"] as? String {
                    if let object = UserDefaults.standard.object(forKey: key) {
                        defaultsToRegister[key] = object
                    }
                }
            }
            UserDefaults.standard.register(defaults: defaultsToRegister)
        }
    }

    static func appName() -> String {
        guard let v = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return "app_name"
        }
        return v
    }

    static func appVersion() -> String {
        guard let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String else {
            return "app_version"
        }
        return v
    }

    static func appBuildVersion() -> String {
        guard let v = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
            return "app_buidl_version"
        }
        return v
    }

    static func updateAppVersionInSettings() {
        let appVersionText = String(format: "%@ (%@)", appVersion(), appBuildVersion())
        UserDefaults.standard.set(appVersionText, forKey: "preference_app_version")
        UserDefaults.standard.synchronize()
    }

    //Unique string used to identify the keychain item:
    static let kKeychainItemIdentifier = "org.veladan.app.uniqueid"

//    + (NSMutableDictionary *)dictionaryToSecItemFormat:(NSString *)identifier
//    {
//    // This method must be called with a properly populated dictionary
//    // containing all the right key/value pairs for a keychain item search.
//
//    // Create the return dictionary:
//    NSMutableDictionary *returnDictionary =
//    [NSMutableDictionary dictionary];
//
//    // Add the keychain item class and the generic attribute:
//    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
//    length:strlen((const char *)kKeychainItemIdentifier)];
//    [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
//    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//
//    // Convert the password NSString to NSData to fit the API paradigm:
//    [returnDictionary setObject:[identifier dataUsingEncoding:NSUTF8StringEncoding]
//    forKey:(__bridge id)kSecValueData];
//    return returnDictionary;
//    }

    
//    // Implement the secItemFormatToDictionary: method, which takes the attribute dictionary
//    //  obtained from the keychain item, acquires the password from the keychain, and
//    //  adds it to the attribute dictionary:
//    + (NSString *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
//    {
//    // This method must be called with a properly populated dictionary
//    // containing all the right key/value pairs for the keychain item.
//
//    // Create a return dictionary populated with the attributes:
//    NSMutableDictionary *returnDictionary = [NSMutableDictionary
//    dictionaryWithDictionary:dictionaryToConvert];
//
//    // To acquire the password data from the keychain item,
//    // first add the search key and class attribute required to obtain the password:
//    [returnDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
//    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//    // Then call Keychain Services to get the password:
//    CFDataRef passwordData = NULL;
//    OSStatus keychainError = noErr; //
//    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary,
//    (CFTypeRef *)&passwordData);
//    if (keychainError == noErr)
//    {
//    // Remove the kSecReturnData key; we don't need it anymore:
//    [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
//
//    // Convert the password to an NSString and add it to the return dictionary:
//    NSString *password = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)passwordData bytes]
//    length:[(__bridge NSData *)passwordData length] encoding:NSUTF8StringEncoding];
//    [returnDictionary setObject:password forKey:(__bridge id)kSecValueData];
//    }
//    // Don't do anything if nothing is found.
//    else if (keychainError == errSecItemNotFound) {
//    NSAssert(NO, @"Nothing was found in the keychain.\n");
//    if (passwordData) CFRelease(passwordData);
//    }
//    // Any other error is unexpected.
//    else
//    {
//    NSAssert(NO, @"Serious error.\n");
//    if (passwordData) CFRelease(passwordData);
//    }
//
//    return returnDictionary[(__bridge id)kSecValueData];
//    }
    
    //public func getOrCreateUniqueIdentifier() -> String {
    //    let userDefaults = NSUserDefaults.standardUserDefaults()
    //    var uniqueId: String!
    //
    //    if userDefaults.objectForKey(kAppUniqueId) == nil {
    //        let uniqueId = NSUUID().UUIDString
    //        userDefaults.setObject(uniqueId, forKey: kAppUniqueId)
    //        userDefaults.synchronize()
    //    } else {
    //        uniqueId = userDefaults.objectForKey(kAppUniqueId) as! String
    //    }
    //    return uniqueId
    //}
    
    
//    + (NSString*)getOrCreateAppUniqueIdentifier {
//
//    NSMutableDictionary* genericPasswordQuery = [[NSMutableDictionary alloc] init];
//    // This keychain item is a generic password.
//    [genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword
//    forKey:(__bridge id)kSecClass];
//    // The kSecAttrGeneric attribute is used to store a unique string that is used
//    // to easily identify and find this keychain item. The string is first
//    // converted to an NSData object:
//    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
//    length:strlen((const char *)kKeychainItemIdentifier)];
//    [genericPasswordQuery setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
//    // Return the attributes of the first match only:
//    [genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
//    // Return the attributes of the keychain item (the password is
//    //  acquired in the secItemFormatToDictionary: method):
//    [genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue
//    forKey:(__bridge id)kSecReturnAttributes];
//
//    OSStatus keychainErr = noErr;
//    CFMutableDictionaryRef outDictionary = nil;
//    // If the keychain item exists, return the attributes of the item:
//    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery,
//    (CFTypeRef *)&outDictionary);
//    if (keychainErr == noErr) {
//    // Convert the data dictionary into the format used by the view controller:
//    return [self secItemFormatToDictionary:(__bridge_transfer NSMutableDictionary *)outDictionary];
//    } else if (keychainErr == errSecItemNotFound) {
//    // Put default values into the keychain if no matching
//    // keychain item is found:
//    if (outDictionary) CFRelease(outDictionary);
//    NSUUID* uuid = [NSUUID UUID];
//    NSString* uuidString = [uuid UUIDString];
//
//
//    OSStatus errorcode = SecItemAdd(
//    (__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:uuidString],
//    NULL);
//    NSAssert(errorcode == noErr, @"Couldn't add the Keychain Item." );
//    return uuidString;
//    } else {
//    // Any other error is unexpected.
//    NSAssert(NO, @"Serious error.\n");
//    if (outDictionary) CFRelease(outDictionary);
//    }
//
//
//
//
//
//    return @"";
//    }

}
