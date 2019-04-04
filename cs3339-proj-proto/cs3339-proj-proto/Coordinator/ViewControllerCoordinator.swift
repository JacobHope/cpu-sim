//
//  ViewControllerCoordinator.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

enum StartState {
    case startPoint1Started
    case noneStarted
}

enum EndState {
    case endPoint1Reached
    case endPoint2Reached
    case noneReached
}

class ViewControllerCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var viewController: ViewController?

    private var startState: StartState = StartState.noneStarted
    private var endState: EndState = EndState.noneReached

    var firstPoint = CGPoint.zero
    var lastPoint = CGPoint.zero

    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let viewController = ViewController(nibName: "ViewController", bundle: nil)
        viewController.delegate = self
        presenter.pushViewController(viewController, animated: true)

        self.viewController = viewController
    }

    func clearDrawing() {
        viewController?.imageView.image = nil
    }

    func ignoreTouchInput() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func resumeTouchInput() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }

    func resetState() {
        startState = StartState.noneStarted
        endState = EndState.noneReached
    }

    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

        if (self.viewController == nil) {
            return
        }

        UIGraphicsBeginImageContext((self.viewController?.view.frame.size)!)

        // Get the graphics context. If it doesn't exist, then return
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        self.viewController?.imageView.image?.draw(
                in: CGRect(
                        x: 0,
                        y: 0,
                        width: (self.viewController?.view.frame.size.width)!,
                        height: (self.viewController?.view.frame.size.height)!))

        context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context.setLineCap(CGLineCap.butt)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context.setBlendMode(CGBlendMode.normal)

        // Draw the line
        context.strokePath()

        self.viewController?.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        self.viewController?.imageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}

extension ViewControllerCoordinator: ViewControllerDelegate {
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self.viewController?.view)
            firstPoint = lastPoint

            self.viewController?.touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    if (touchPoint.name == "startTouchPoint") {
                        print("onTouchPointBegan startTouchPoint")

                        self.startState = StartState.startPoint1Started
                    }
                }
            }
        }
    }


    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.viewController == nil) {
            return
        }

        if let touch = touches.first {
            let currentPoint = touch.location(in: self.viewController?.view)
            drawLineFrom(fromPoint: self.lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint

            self.viewController?.touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch touchPoint.name {
                    case "endTouchPoint1":
                        print("onTouchPointMoved endTouchPoint1")

                        if (self.startState == StartState.startPoint1Started) {
                            // Change endTouchPoint1 to dark red color...
                            touchPoint.pulsator?.backgroundColor = UIColor.darkRed.cgColor

                            // ...then change back to blue color after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                touchPoint.pulsator?.backgroundColor = UIColor.blue.cgColor
                            }
                        }

                        self.ignoreTouchInput()
                        self.clearDrawing()
                        break;
                    case "endTouchPoint2":
                        print("onTouchPointMoved endTouchPoint2")

                        if (self.startState == StartState.startPoint1Started) {
                            // Change endTouchPoint2 to green color...
                            touchPoint.pulsator?.backgroundColor = UIColor.green.cgColor

                            // ...then stop pulsating after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                touchPoint.pulsator?.stop()
                            }
                        }

                        self.ignoreTouchInput()
                        self.clearDrawing()
                        break;

                    default:
                        // Do nothing
                        break;
                    }
                }
            }
        }
    }

    func onTouchesEnded() {
        self.resetState()
    }

    func onTouchesCancelled() {
        self.resumeTouchInput()
        self.resetState()
    }
}
