//
//  UIViewController+imageBackground.swift
//  OSFramework
//
//  Created by Daniel Vela on 27/04/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

import UIKit

public extension UIViewController {
    @objc func setAppBackground(imageName: String) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        view.insertSubview(backgroundImage, at: 0)
    }
}

public extension UITableViewController {
    override func setAppBackground(imageName: String) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        self.tableView.backgroundView = backgroundImage
    }
}
