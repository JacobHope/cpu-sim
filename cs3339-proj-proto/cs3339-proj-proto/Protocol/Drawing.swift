//
//  Drawing.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

protocol Drawing {
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, inViewController viewController: ViewController)
    func clearDrawing(inViewController viewController: ViewController)
    func ignoreTouchInput()
    func resumeTouchInput()
}
