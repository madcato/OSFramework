//
//  WaitButton.swift
//  OSFramework
//
//  Created by Daniel Vela Angulo on 07/02/2019.
//  Copyright © 2019 Daniel Vela. All rights reserved.
//

import UIKit

protocol WaitButtonProtocol {
    var activityStyle: UIActivityIndicatorView.Style { get set }
    /// Call this method to set the original state of the button.
    /// (The waiting view is removed and the button becomes active)
    func reset()
}

/// This class is a UIButton extension that shows an activity view when user taps it.
/// Also the button become disabled when user taps it, until method *reset* is called.
///
@IBDesignable
class WaitButton: UIButton {
    var activityStyle = UIActivityIndicatorView.Style.gray
    private lazy var activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView.init(style: activityStyle)
        // Set the control in the middle of the button
        let position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        activity.center = position
        addSubview(activity)
        setTitle("", for: UIControl.State.disabled)  // To hide the title label when button is disabled
        return activity
    }()

    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        // Activate waiting view
        activityView.startAnimating()
        // Disable button
        isEnabled = false
        // Call this to dispatch the action to the target
        super.sendAction(action, to: target, for: event)
    }
}

extension WaitButton: WaitButtonProtocol {
    func reset() {
        activityView.stopAnimating()
        isEnabled = true
    }
}
