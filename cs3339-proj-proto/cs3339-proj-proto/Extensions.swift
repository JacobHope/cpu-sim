//
//  Extensions.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

// MARK: StoryboardInstantiable

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

// MARK: Pulsator

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
