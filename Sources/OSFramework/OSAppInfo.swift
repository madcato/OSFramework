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
        guard let appNameStr = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return "app_name"
        }
        return appNameStr
    }

    static func appVersion() -> String {
        guard let appVersionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String else {
            return "app_version"
        }
        return appVersionStr
    }

    static func appBuildVersion() -> String {
        guard let appBuildVersionStr = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
            return "app_buidl_version"
        }
        return appBuildVersionStr
    }

    static func updateAppVersionInSettings() {
        let appVersionText = String(format: "%@ (%@)", appVersion(), appBuildVersion())
        UserDefaults.standard.set(appVersionText, forKey: "preference_app_version")
        UserDefaults.standard.synchronize()
    }
}
