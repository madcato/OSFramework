//
//  OSCircleLabel.swift
//  CircleImageProject
//
//  Created by Daniel Vela on 15/04/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

@IBDesignable
class OSCircleLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createMask()
    }

    func createMask() {
        var radious = self.bounds.size.height < self.bounds.size.width ?
            self.bounds.size.height : self.bounds.size.width
        radious /= 2

        // Calculate bounding box with radious from the center of the view
        let xPos = (self.bounds.size.width / 2) - CGFloat(radious)
        let yPos = (self.bounds.size.height / 2) - CGFloat(radious)
        let width = CGFloat(radious) * 2
        let height = CGFloat(radious) * 2

        let circleLayer = CAShapeLayer.init()
        circleLayer.path = UIBezierPath.init(ovalIn: CGRect(x: xPos, y: yPos, width: width, height: height)).cgPath

        self.layer.mask = circleLayer
    }

}
