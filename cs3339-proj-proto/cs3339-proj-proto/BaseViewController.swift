//
//  BaseViewController.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

class BaseViewController: UIViewController {
    var firstPoint = CGPoint.zero
    var lastPoint = CGPoint.zero

    var imageViewBase: UIImageView?
    var endTouchPointBase: UIView?
    var startTouchPointBase: UIView?

    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (imageViewBase == nil
            || endTouchPointBase == nil
            || startTouchPointBase == nil) {
            return
        }

        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint

            // Detect if touch is inside touchPoint
            guard let touchPointHitView = view.hitTest(
                    CGPoint(x: touch.location(in: view).x + endTouchPointBase!.frame.width / 2,
                            y: touch.location(in: view).y + endTouchPointBase!.frame.height / 2),
                    with: event)
                    else {
                return
            }

            if (touchPointHitView == endTouchPointBase) {
                print("MOVED \(touchPointHitView)")
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (imageViewBase == nil
                || endTouchPointBase == nil
                || startTouchPointBase == nil) {
            return
        }

        if let touch = touches.first {

            // Detect if touch is inside touchPoint
            guard let hitView = view.hitTest(
                    CGPoint(x: touch.location(in: view).x + endTouchPointBase!.frame.width / 2,
                            y: touch.location(in: view).y + endTouchPointBase!.frame.height / 2),
                    with: event)
                    else {
                return
            }

            if (hitView == endTouchPointBase) {
                print("ENDED \(hitView)")
            }
        }
    }

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
    
    func createPulsator(radius: CGFloat) -> Pulsator {
        let pulsator = Pulsator()
        pulsator.numPulse = 3
        pulsator.radius = radius
        pulsator.backgroundColor = UIColor.blue.cgColor
        pulsator.animationDuration = 3
        pulsator.pulseInterval = 0.1
        pulsator.repeatCount = Float(INT32_MAX)
            
        return pulsator
    }
}
