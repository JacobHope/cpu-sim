//
//  LineView.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/6/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

class LineView: UIImageView {
    @IBInspectable var endPointName: String = "endTouchPoint"
    
    func setup() {
        self.alpha = 0.0
    }
}
