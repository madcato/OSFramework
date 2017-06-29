//
//  File.swift
//  OSFramework
//
//  Created by Daniel Vela on 29/06/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

// DO NOT COMPILE THIS FILE


// Ask user to enter pin
// or authenticate throw TouchID setting LAPolicy.deviceOwnerAuthenticationWithBiometrics
// https://developer.apple.com/documentation/localauthentication
import LocalAuthentication

let myContext = LAContext()
let myLocalizedReasonString = "To access wallet"

var authError: NSError? = nil
if #available(iOS 8.0, OSX 10.12, *) {
    if myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError) {
        myContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
            if (success) {
                // User authenticated successfully, take appropriate action
                NSLog("OK ")
            } else {
                // User did not authenticate successfully, look at error and take appropriate action
                NSLog("BAD Auth ")
            }
        }
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        NSLog("Unavailable ")
    }
} else {
    // Fallback on earlier versions
    NSLog("Version ")
}
