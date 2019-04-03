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

    // MARK: IBOutlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startTouchPoint: TouchPointView!
    @IBOutlet weak var endTouchPoint1: TouchPointView!
    @IBOutlet weak var endTouchPoint2: TouchPointView!

    var touchPoints: [TouchPointView] = []

    // MARK: UIKit

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup TouchPointViews
        touchPoints = [startTouchPoint, endTouchPoint1, endTouchPoint2]
        touchPoints.forEach { touchPoint in
            touchPoint.setup()
        }
    }

    // MARK: IBActions

    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
    }
}
