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
    private let drawingService: Drawing

    private var startState: StartState = StartState.noneStarted
    private var endState: EndState = EndState.noneReached

    var firstPoint = CGPoint.zero
    var lastPoint = CGPoint.zero

    init(presenter: UINavigationController,
         drawingService: Drawing) {
        self.presenter = presenter
        self.drawingService = drawingService
    }

    func start() {
        let viewController = ViewController(nibName: "ViewController", bundle: nil)
        viewController.delegate = self
        presenter.pushViewController(viewController, animated: true)

        self.viewController = viewController
    }

    func resetState() {
        startState = StartState.noneStarted
        endState = EndState.noneReached
    }

    func onCorrect(_ touchPoint: TouchPointView) {
        // Change touch point to green color...
        touchPoint.pulsator?.backgroundColor = UIColor.green.cgColor

        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.pulsator?.stop()

            switch touchPoint.name {
            case "endTouchPoint2":
                UIView.animate(withDuration: 1.0, animations: {
                    self.viewController?.line1.isHidden = false
                })

                break;
            default:
                break;
            }
        }
    }

    func onIncorrect(_ touchPoint: TouchPointView) {
        // Change endTouchPoint1 to dark red color...
        touchPoint.pulsator?.backgroundColor = UIColor.darkRed.cgColor

        // ...then change back to blue color after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.pulsator?.backgroundColor = UIColor.blue.cgColor
        }
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
            drawingService.drawLineFrom(
                    fromPoint: self.lastPoint,
                    toPoint: currentPoint,
                    inViewController: self.viewController!)

            lastPoint = currentPoint

            self.viewController?.touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch touchPoint.name {
                    case "endTouchPoint1":
                        print("onTouchPointMoved endTouchPoint1")

                        if (self.startState == StartState.startPoint1Started) {
                            self.onIncorrect(touchPoint)
                        }

                        drawingService.ignoreTouchInput()
                        drawingService.clearDrawing(inViewController: self.viewController!)
                        break;
                    case "endTouchPoint2":
                        print("onTouchPointMoved endTouchPoint2")

                        if (self.startState == StartState.startPoint1Started) {
                            self.onCorrect(touchPoint)
                        }

                        drawingService.ignoreTouchInput()
                        drawingService.clearDrawing(inViewController: self.viewController!)
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
        drawingService.resumeTouchInput()
        self.resetState()
    }

    func clearDrawing() {
        if (self.viewController == nil) {
            return
        }
        drawingService.clearDrawing(inViewController: self.viewController!)
    }
}
