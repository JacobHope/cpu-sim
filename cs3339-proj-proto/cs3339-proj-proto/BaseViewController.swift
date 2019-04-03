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

    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint)
}

class BaseViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?

    var firstPoint = CGPoint.zero
    var lastPoint = CGPoint.zero

    var imageViewBase: UIImageView?
    var touchPoints: [TouchPointView] = []

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
            delegate?.drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)

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

    // MARK: Initialization

    func setupTouchPointViews() {
        // Setup start TouchPointViews
        touchPoints.forEach { touchPoint in
            touchPoint.setup()
        }
    }


}
