//
//  StateService.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

private enum StartState {
    case startPoint1Started
    case noneStarted
}

private enum EndState {
    case endPoint1Reached
    case endPoint2Reached
    case noneReached
}

class StateService: State {
    private var startState: StartState = StartState.noneStarted
    private var endState: EndState = EndState.noneReached

    private var firstPoint = CGPoint.zero
    private var lastPoint = CGPoint.zero

    func resetState() {
        startState = StartState.noneStarted
        endState = EndState.noneReached
    }

    private func onCorrect(
            _ touchPoint: TouchPointView,
            inViewController viewController: ViewController) {

        // Change touch point to green color...
        touchPoint.pulsator?.backgroundColor = UIColor.green.cgColor

        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.pulsator?.stop()

            switch touchPoint.name {
            case "endTouchPoint2":
                UIView.animate(withDuration: 1.0, animations: {
                    viewController.line1.isHidden = false
                })

                break;
            default:
                break;
            }
        }
    }

    private func onIncorrect(_ touchPoint: TouchPointView) {
        // Change endTouchPoint1 to dark red color...
        touchPoint.pulsator?.backgroundColor = UIColor.darkRed.cgColor

        // ...then change back to blue color after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.pulsator?.backgroundColor = UIColor.blue.cgColor
        }
    }

    func handleTouchesBegan(
            _ touches: Set<UITouch>,
            with event: UIEvent?,
            inViewController viewController: ViewController) {

        if let touch = touches.first {
            lastPoint = touch.location(in: viewController.view)
            firstPoint = lastPoint

            viewController.touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    if (touchPoint.name == "startTouchPoint") {
                        self.startState = StartState.startPoint1Started
                    }
                }
            }
        }
    }

    func handleTouchesMoved(
            _ touches: Set<UITouch>,
            with event: UIEvent?,
            inViewController viewController: ViewController,
            withDrawing drawingService: Drawing) {

        if let touch = touches.first {
            let currentPoint = touch.location(in: viewController.view)
            drawingService.drawLineFrom(
                    fromPoint: self.lastPoint,
                    toPoint: currentPoint,
                    inViewController: viewController)

            lastPoint = currentPoint

            viewController.touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch touchPoint.name {
                    case "endTouchPoint1":
                        if (self.startState == StartState.startPoint1Started) {
                            self.onIncorrect(touchPoint)
                        }

                        drawingService.ignoreTouchInput()
                        drawingService.clearDrawing(inViewController: viewController)
                        break;
                    case "endTouchPoint2":
                        if (self.startState == StartState.startPoint1Started) {
                            self.onCorrect(touchPoint, inViewController: viewController)
                        }

                        drawingService.ignoreTouchInput()
                        drawingService.clearDrawing(inViewController: viewController)
                        break;

                    default:
                        // Do nothing
                        break;
                    }
                }
            }
        }
    }

    func handleTouchesEnded() {
        self.resetState()
    }

    func handleTouchesCancelled(withDrawing drawingService: Drawing) {
        drawingService.resumeTouchInput()
        self.resetState()
    }
}
