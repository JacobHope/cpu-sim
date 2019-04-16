//
//  DrawingService.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

class DrawingService: Drawing {
    func drawLineFrom(
            fromPoint: CGPoint,
            toPoint: CGPoint,
            imageView: UIImageView,
            view: UIView) {

        UIGraphicsBeginImageContext(view.frame.size)

        // Get the graphics context. If it doesn't exist, then return
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        imageView.image?.draw(
                in: CGRect(
                        x: 0,
                        y: 0,
                        width: view.frame.size.width,
                        height: view.frame.size.height))

        context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context.setLineCap(LineAttributes.lineCap)
        context.setLineWidth(LineAttributes.brushWidth)
        context.setStrokeColor(
                red: LineAttributes.red,
                green: LineAttributes.green,
                blue: LineAttributes.blue,
                alpha: LineAttributes.alpha)
        context.setBlendMode(LineAttributes.blendMode)

        // Draw the line
        context.strokePath()

        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = LineAttributes.opacity
        UIGraphicsEndImageContext()
    }

    func clearDrawing(imageView: UIImageView) {
        imageView.image = nil
    }

    func ignoreTouchInput() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func resumeTouchInput() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
