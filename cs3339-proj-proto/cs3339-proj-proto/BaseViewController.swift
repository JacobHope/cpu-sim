//
//  BaseViewController.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

protocol ViewControllerDelegate: class {
    func onTouchPointBegan(_ touchPoint: TouchPointView)
    func onTouchPointMoved(_ touchPoint: TouchPointView)
    func onTouchesEnded()
    func onTouchesCancelled()
}

class BaseViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?

    var firstPoint = CGPoint.zero
    var lastPoint = CGPoint.zero

    var imageViewBase: UIImageView?
    var touchPoints: [TouchPointView] = []

    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0

    // MARK: UIKit

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
            firstPoint = lastPoint

            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    delegate?.onTouchPointBegan(touchPoint)
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (imageViewBase == nil) {
            return
        }

        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint

            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    delegate?.onTouchPointMoved(touchPoint)
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouchesEnded()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouchesCancelled()
    }

    // MARK: Drawing

    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

        if (imageViewBase == nil) {
            return
        }

        UIGraphicsBeginImageContext(view.frame.size)

        // Get the graphics context. If it doesn't exist, then return
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        imageViewBase!.image?.draw(
                in: CGRect(
                        x: 0,
                        y: 0,
                        width: view.frame.size.width,
                        height: view.frame.size.height))

        context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context.setLineCap(CGLineCap.butt)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context.setBlendMode(CGBlendMode.normal)

        // Draw the line
        context.strokePath()

        imageViewBase!.image = UIGraphicsGetImageFromCurrentImageContext()
        imageViewBase!.alpha = opacity
        UIGraphicsEndImageContext()
    }

    // MARK: Initialization

    func setupTouchPointViews() {
        // Setup start TouchPointViews
        touchPoints.forEach { touchPoint in
            touchPoint.setup()
        }
    }


}
