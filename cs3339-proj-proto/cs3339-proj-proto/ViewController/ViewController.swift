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

    @IBOutlet weak var line21: LineView!
    @IBOutlet weak var line22: LineView!
    @IBOutlet weak var line23: LineView!

    var touchPoints: [TouchPointView] = []
    var lines: [LineView] = []

    // MARK: UIKit

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup TouchPointViews
        touchPoints = [startTouchPoint, endTouchPoint1, endTouchPoint2]
        lines = [line21, line22, line23]

        delegate?.setup()
    }

    // MARK: IBActions

    @IBAction func reset(_ sender: Any) {
        delegate?.clearDrawing()
    }
}
