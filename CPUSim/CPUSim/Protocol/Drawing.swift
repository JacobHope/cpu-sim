//
//  Drawing.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

protocol Drawing {
    func drawLineFrom(
            fromPoint: CGPoint,
            toPoint: CGPoint,
            imageView: UIImageView,
            view: UIView)

    func clearDrawing(imageView: UIImageView)
    func ignoreTouchInput()
    func resumeTouchInput()
}
