//
//  ViewController.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var touchPoint: UIView!

    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var dragged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let pulsator = Pulsator()
        pulsator.numPulse = 3
        pulsator.radius = 50.0
        pulsator.backgroundColor = UIColor.lightGray.cgColor
        pulsator.animationDuration = 3
        pulsator.pulseInterval = 0.1
        pulsator.repeatCount = Float(INT32_MAX)

        touchPoint.layer.addSublayer(pulsator)

        pulsator.start()
    }

    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragged = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragged = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !dragged {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }

    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
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

        context.setLineCap(CGLineCap.butt)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context.setBlendMode(CGBlendMode.normal)

        // Draw the line
        context.strokePath()

        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}
