//
//  TitleShadowButton.swift
//  OSFramework
//
//  Created by Daniel Vela on 29/04/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import QuartzCore

class TitleShadowButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
        setTitleShadowColor(UIColor.black, for: .normal)
        titleLabel?.clipsToBounds = false
    }
}
