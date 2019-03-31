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
    @IBOutlet weak var startTouchPointView: TouchPointView!
    @IBOutlet weak var endTouchPointView1: TouchPointView!
    @IBOutlet weak var endTouchPointView2: TouchPointView!

    // MARK: UIKit

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Assign imageView to baseImageView so BaseViewController handles drawing
        imageViewBase = imageView

        // Keep track of TouchPointViews
        startTouchPoints = [startTouchPointView]
        endTouchPoints = [endTouchPointView1, endTouchPointView2]
        
        // Setup TouchPointViews
        setupTouchPointViews()
    }

    // MARK: IBActions

    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
    }
}
