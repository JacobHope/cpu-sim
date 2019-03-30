//
//  ViewController.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

class ViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var endTouchPoint: UIView!
    @IBOutlet weak var startTouchPoint: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup startPoint
        let startPointPulsator = createPulsator(radius: startTouchPoint.frame.width)
        startTouchPoint.layer.addSublayer(startPointPulsator)
        startPointPulsator.start()

        // Setup touchPoint
        let endTouchPointPulsator = createPulsator(radius: endTouchPoint.frame.width)
        endTouchPoint.layer.addSublayer(endTouchPointPulsator)
        endTouchPointPulsator.start()

        imageViewBase = imageView
        endTouchPointBase = endTouchPoint
        startTouchPointBase = startTouchPoint
    }

    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
    }
}
