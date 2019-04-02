//
//  TouchPointView.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

class TouchPointView: UIView {
    var pulsator: Pulsator?
    
    @IBInspectable var name: String = "touchPoint"

    func setup() {
        // Generate a Pulsator instance
        let pulsator = Pulsator.generatePulsator(radius: self.frame.width, backgroundColor: UIColor.blue.cgColor)

        // Add Pulsator as a sublayer to TouchPointView
        self.layer.addSublayer(pulsator)

        // Start pulsating
        pulsator.start()

        // Keep track of pulsator in order to change color, toggle off, etc
        self.pulsator = pulsator
    }
}
