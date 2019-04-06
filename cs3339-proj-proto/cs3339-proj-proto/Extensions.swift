//
//  Extensions.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

extension StoryboardInstantiable where Self: UIViewController {
    static var defaultfilesName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let sb = UIStoryboard(name: fileName, bundle: bundle)
        return sb.instantiateInitialViewController() as! Self
    }
}

extension Pulsator {
    static func generatePulsator(radius: CGFloat,
                                 backgroundColor: CGColor) -> Pulsator {
        let pulsator = Pulsator()
        pulsator.numPulse = 3
        pulsator.radius = radius
        pulsator.backgroundColor = backgroundColor
        pulsator.animationDuration = 3
        pulsator.pulseInterval = 0.1
        pulsator.repeatCount = Float(INT32_MAX)

        return pulsator
    }
}

extension UIColor {
    static let darkRed = UIColor(red: 0.667, green: 0, blue: 0, alpha: 1.0)
}

extension CAShapeLayer {
    static func generateDotWith(
            x: CGFloat,
            y: CGFloat,
            radius: CGFloat,
            color: CGColor) -> CAShapeLayer {

        let dot = CAShapeLayer()
        dot.path = UIBezierPath(
                ovalIn: CGRect(
                        x: x,
                        y: y,
                        width: radius,
                        height: radius)).cgPath
        dot.fillColor = color
        return dot
    }
}
