//
//  DotModel.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/7/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import Foundation
import UIKit

struct DotModel {
    let x: CGFloat
    let y: CGFloat
    let radius: CGFloat

    init(x: CGFloat, y: CGFloat, radius: CGFloat) {
        self.x = x
        self.y = y
        self.radius = radius
    }
}
