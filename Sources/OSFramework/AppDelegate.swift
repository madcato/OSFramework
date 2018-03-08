//
//  AppDelegate.swift
//  OSFramework
//
//  Created by Daniel Vela on 30/01/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

// Sample code. Don't compile it

@available(iOS 9.0, *)
func application(_ application: UIApplication,
                 open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
    if url.scheme == "happic" {
        return handleHappicScheme(url)
    }
    return false
}

func application(_ application: UIApplication,
                 open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if url.scheme == "happic" {
        return handleHappicScheme(url)
    }
    return false
}

func handleHappicScheme(_ url: URL) -> Bool {
    let pathComponents = url.pathComponents
    let firstComponent = pathComponents[1]
    if firstComponent == "share" {
        if self.session.userIdentification.count == 0 {
            // Login is not already made. Wait until made it
            shareURL = url
        } else {
            askUserToAccept(url)
        }
        return true
    }
    if firstComponent == "register" {
        HPCMomentManager.makeDataDirt()
        let otp = pathComponents[3]
        let mail = SimplePersistence.string(forKey: HPCLoginViewController.kUserEmailID)
        let name = SimplePersistence.string(forKey: HPCLoginViewController.kUserNameID)
        doRegister(otp, name: name!, mail: mail!)
        return true
    }
    if url.host == "payment" {
        let result = firstComponent
        if result == "ok" {
            // Reload picture
            let center = NotificationCenter.default
            center.post(name: Notification.Name(rawValue: "PaymentResultOk"), object: nil)
        }
        if result == "error" {
            // Toast "Se ha producido un error en el pago"
            showToast("Error en el pago", submsg: nil)
        }
        if result == "cancelled" {
            // Do nothing
        }
    }
    return false
}
