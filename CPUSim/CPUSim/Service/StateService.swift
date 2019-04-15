//
//  StateService.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import PromiseKit
import PMKUIKit

// todo: rename StateService to ALUFetchStateService
private enum StartState {
    case ifMuxToPcStartStarted
    case ifMuxToPcEndStarted
    case noneStarted
}

private enum EndState {
    case ifMuxToPcStartEnded
    case ifMuxToPcEndEnded
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

    // todo: pass in all touch points
    // todo: pass in name of endPoint
    // todo: hide appropriate touch points based on name of endPoints
    private func onCorrect(
            _ touchPoint: TouchPointView,
            lines: [LineView]) {

        // Set touch point correct...
        touchPoint.setCorrect()

        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.stop()


            // Animate each line in sequence
            var animate = Guarantee()
            for line in lines {
                animate = animate.then {
                    UIView.animate(.promise, duration: 0.75) {
                        line.alpha = 1.0
                    }.asVoid()
                }
            }

            switch touchPoint.name {
            case "ifMuxToPcEnd":
                // Hide the touchPoints

                break;
            default:
                break;
            }
        }
    }

    private func onIncorrect(_ touchPoint: TouchPointView) {
        // Set touch point incorrect...
        touchPoint.setIncorrect()

        // ...then reset after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.reset()
        }
    }

    func handleTouchesBegan(
            _ touches: Set<UITouch>,
            with event: UIEvent?,
            touchPoints: [TouchPointView],
            view: UIView) {

        if let touch = touches.first {
            lastPoint = touch.location(in: view)
            firstPoint = lastPoint

            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    if (touchPoint.name == "ifMuxToPcStart") {
                        print("! 1")
                        self.startState = StartState.ifMuxToPcStartStarted
                    }
                    if (touchPoint.name == "ifMuxToPcEnd") {
                        print("! 2")
                        self.startState = StartState.ifMuxToPcEndStarted
                    }
                }
            }
        }
    }

    func handleTouchesMoved(
            _ touches: Set<UITouch>,
            with event: UIEvent?,
            imageView: UIImageView,
            view: UIView,
            withDrawing drawingService: Drawing,
            touchPoints: [TouchPointView],
            lines: [String: [LineView]]) {

        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            print(currentPoint)
            drawingService.drawLineFrom(
                    fromPoint: self.lastPoint,
                    toPoint: currentPoint,
                    imageView: imageView,
                    view: view)

            lastPoint = currentPoint

            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch touchPoint.name {
                    case "ifMuxToPcStart":  // Anything ending at a start point is incorrect
                        if (startState != StartState.ifMuxToPcStartStarted) {
                            self.onIncorrect(touchPoint)
                            drawingService.ignoreTouchInput()
                            drawingService.clearDrawing(imageView: imageView)
                        }
                        break;
                    case "ifMuxToPcEnd":
                        if (self.startState == StartState.ifMuxToPcStartStarted) {
                            self.onCorrect(touchPoint, lines: lines["ifMuxToPc"]!)
                            drawingService.ignoreTouchInput()
                            drawingService.clearDrawing(imageView: imageView)
                        }
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
