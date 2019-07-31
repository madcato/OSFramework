//
//  OSCircleImageView.swift
//  CircleImageProject
//
//  Created by Daniel Vela on 15/04/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

@IBDesignable
class OSCircleImageView: UIImageView {

    @IBInspectable var radious: Int = 100 {
        didSet {
            createMask()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func createMask() {
        // Calculate bounding box with radious from the center of the view
        let xPos = (self.bounds.size.width / 2) - CGFloat(radious)
        let yPos = (self.bounds.size.height / 2) - CGFloat(radious)
        let width = CGFloat(radious) * 2
        let height = CGFloat(radious) * 2
        let circleLayer = CAShapeLayer.init()
        circleLayer.path = UIBezierPath.init(ovalIn: CGRect(x: xPos,
                                                            y: yPos,
                                                            width: width,
                                                            height: height)).cgPath
        self.layer.mask = circleLayer
    }
}
