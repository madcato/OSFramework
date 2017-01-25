//
//  UIAppDelegate+ChangeRootController.swift
//  MobilePay
//
//  Created by Daniel Vela on 02/08/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

public extension UIResponder {
    func changeRootControllerTo(_ viewController: UIViewController, window: UIWindow?, onEnd: @escaping (_ ended: Bool) -> ()) {
        // Show main view with animation
        UIView.transition(with: window!, duration: 0.8, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            window?.rootViewController = viewController
        }) { (ended: Bool) in
            onEnd(ended)
        }
    }
}
