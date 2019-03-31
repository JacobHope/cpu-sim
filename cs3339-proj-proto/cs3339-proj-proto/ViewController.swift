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
    @IBOutlet weak var endTouchPoint: TouchPointView!
    @IBOutlet weak var endTouchPoint2: TouchPointView!
    @IBOutlet weak var startTouchPoint: TouchPointView!

    // MARK: UIKit

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Assign imageView to baseImageView so BaseViewController handles drawing
        imageViewBase = imageView

        // Keep track of TouchPointViews
        startTouchPoints = [startTouchPoint]
        endTouchPoints = [endTouchPoint, endTouchPoint2]
        
        // Setup TouchPointViews
        setupTouchPointViews()
    }

    // MARK: IBActions

    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
    }
}
