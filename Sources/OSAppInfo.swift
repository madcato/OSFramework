//
//  OSAppInfo.swift
//  OSFramework
//
//  Created by Daniel Vela on 22/01/2018.
//  Copyright © 2018 Daniel Vela. All rights reserved.
//

import Foundation

class OSAppInfo {
    static func appName() -> String {
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return "app_name"
        }
        return appName
    }

    static func appVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String else {
            return "app_version"
        }
        return appVersion
    }

    static func appBuildVersion() -> String {
        guard let appBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
            return "app_buidl_version"
        }
        return appBuildVersion
    }

    static func updateAppVersionInSettings() {
        let appVersionText = String(format: "%@ (%@)", appVersion(), appBuildVersion())
        UserDefaults.standard.set(appVersionText, forKey: "preference_app_version")
        UserDefaults.standard.synchronize()
    }
}
