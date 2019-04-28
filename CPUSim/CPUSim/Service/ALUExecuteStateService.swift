//
//  ALUExecuteStateService.swift
//  CPUSim
//
//  Created by Connor Reid on 4/27/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit
import SwiftEventBus

private enum StartState {
    case exIdAddToAddStartStarted
    case exIdAddToAddEndStarted
    case exShiftLeftToAddStartStarted
    case exShiftLeftToAddEndStarted
    case exAluToMemStartStarted
    case exAluToMemEndStarted
    case exIdSignExtendToShiftLeftStartStarted
    case exIdSignExtendToShiftLeftEndStarted
    case exIdSignExtendToMuxEndStarted
    case exIdReadDataOneToAluStartStarted
    case exIdReadDataOneToAluEndStarted
    case exIdReadDataTwoToMuxStartStarted
    case exIdReadDataTwoToMuxEndStarted
    case exMuxToAluStartStarted
    case exMuxToAluEndStarted
    case noneStarted
}

class ALUExecuteStateService: State {
    var isDrawing: Bool = false

    var correctnessMap: [String: Bool] = [
        CorrectnessMapKeys.exIdAddToAdd: false,
        CorrectnessMapKeys.exShiftLeftToAdd: false,
        CorrectnessMapKeys.exAluToMem: false,
        CorrectnessMapKeys.exIdSignExtendToShiftLeft: false,
        CorrectnessMapKeys.exIdSignExtendToMux: false,
        CorrectnessMapKeys.exIdReadDataOneToAlu: false,
        CorrectnessMapKeys.exIdReadDataTwoToMux: false,
        CorrectnessMapKeys.exMuxToAlu: false
    ]

    private var touchStartedInTouchPoint: Bool = false

    private var startState: StartState = StartState.noneStarted

    private var firstPoint = CGPoint.zero
    private var lastPoint = CGPoint.zero

    func resetState() {
        startState = StartState.noneStarted
        touchStartedInTouchPoint = false
        isDrawing = false
    }

    private func onCorrect(
            _ touchPoints: [TouchPointView],
            touchPointName: String,
            linesMap: [String: [LineView]]) {

        // Set touch point correct...
        switch touchPointName {
        case TouchPointNames.exIdAddToAddEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exIdAddToAdd] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exIdAddToAddEnd
                        || tp.name == TouchPointNames.exIdAddToAddStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exShiftLeftToAddEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exShiftLeftToAdd] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exShiftLeftToAddEnd
                        || tp.name == TouchPointNames.exShiftLeftToAddStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exAluToMemEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exAluToMem] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exAluToMemEnd
                        || tp.name == TouchPointNames.exAluToMemStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exIdSignExtendToShiftLeftEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exIdSignExtendToShiftLeft] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exIdSignExtendToShiftLeftEnd
                        || tp.name == TouchPointNames.exIdSignExtendToShiftLeftStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exIdSignExtendToMuxEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exIdSignExtendToMux] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exIdSignExtendToMuxEnd
                        || tp.name == TouchPointNames.exIdSignExtendToShiftLeftEnd) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exIdReadDataOneToAluEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exIdReadDataOneToAlu] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exIdReadDataOneToAluEnd
                        || tp.name == TouchPointNames.exIdReadDataOneToAluStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exIdReadDataTwoToMuxEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exIdReadDataTwoToMux] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exIdReadDataTwoToMuxEnd
                        || tp.name == TouchPointNames.exIdReadDataTwoToMuxStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.exMuxToAluEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.exMuxToAlu] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.exMuxToAluEnd
                        || tp.name == TouchPointNames.exMuxToAluStart) {
                    tp.setCorrect()
                }
            }
            break;
        default:
            break;
        }

        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Hide touch points
            switch touchPointName {
            case TouchPointNames.exIdAddToAddEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exIdAddToAddEnd
                            || tp.name == TouchPointNames.exIdAddToAddStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.exIdSignExtendToShiftLeftEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exIdSignExtendToShiftLeftEnd) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.exIdSignExtendToShiftLeft] == true
                            && self.correctnessMap[CorrectnessMapKeys.exIdSignExtendToMux] == true
                            && tp.name == TouchPointNames.exIdSignExtendToShiftLeftStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.exIdSignExtendToShiftLeftStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.exIdSignExtendToMuxEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exIdSignExtendToMuxEnd) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.exIdSignExtendToShiftLeft] == true
                            && self.correctnessMap[CorrectnessMapKeys.exIdSignExtendToMux] == true
                            && tp.name == TouchPointNames.exIdSignExtendToShiftLeftStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.exIdSignExtendToShiftLeftStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.exShiftLeftToAddEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exShiftLeftToAddEnd
                            || tp.name == TouchPointNames.exShiftLeftToAddStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.exAluToMemEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exAluToMemEnd
                            || tp.name == TouchPointNames.exAluToMemStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.exIdReadDataOneToAluEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exIdReadDataOneToAluEnd
                            || tp.name == TouchPointNames.exIdReadDataOneToAluStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.exIdReadDataTwoToMuxEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exIdReadDataTwoToMuxEnd
                            || tp.name == TouchPointNames.exIdReadDataTwoToMuxStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.exMuxToAluEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.exMuxToAluEnd
                            || tp.name == TouchPointNames.exMuxToAluStart) {
                        tp.isHidden = true
                    }
                }
                break;
            default:
                break;
            }

            // Animate lines
            LineView.animateLines(
                    linesMap[touchPointName] ?? [],
                    duration: 0.75)
        }

        // Post event...
        SwiftEventBus.post(Events.aluExecuteOnCorrect, sender: determineProgress())
    }

    private func determineProgress() -> Float {
        var progress: Float = 0
        let total: Float = correctnessMap.count == 0 ? 1 : Float(correctnessMap.count)
        for (_, v) in correctnessMap {
            if (v == true) {
                progress += 1
            }
        }
        return progress / total
    }

    private func onIncorrect(
            _ touchPoints: [TouchPointView],
            touchPointName: String) {

        let startName: String
        let endName = touchPointName

        switch startState {
        case StartState.exIdAddToAddStartStarted:
            startName = TouchPointNames.exIdAddToAddStart
            break;
        case StartState.exIdAddToAddEndStarted:
            startName = TouchPointNames.exIdAddToAddEnd
            break;
        case StartState.exShiftLeftToAddStartStarted:
            startName = TouchPointNames.exShiftLeftToAddStart
            break;
        case StartState.exShiftLeftToAddEndStarted:
            startName = TouchPointNames.exShiftLeftToAddEnd
            break;
        case StartState.exAluToMemStartStarted:
            startName = TouchPointNames.exAluToMemStart
            break;
        case StartState.exAluToMemEndStarted:
            startName = TouchPointNames.exAluToMemEnd
            break;
        case StartState.exIdSignExtendToShiftLeftStartStarted:
            startName = TouchPointNames.exIdSignExtendToShiftLeftStart
            break;
        case StartState.exIdSignExtendToShiftLeftEndStarted:
            startName = TouchPointNames.exIdSignExtendToShiftLeftEnd
            break;
        case StartState.exIdSignExtendToMuxEndStarted:
            startName = TouchPointNames.exIdSignExtendToMuxEnd
            break;
        case StartState.exIdReadDataOneToAluStartStarted:
            startName = TouchPointNames.exIdReadDataOneToAluStart
            break;
        case StartState.exIdReadDataOneToAluEndStarted:
            startName = TouchPointNames.exIdReadDataOneToAluEnd
            break;
        case StartState.exIdReadDataTwoToMuxStartStarted:
            startName = TouchPointNames.exIdReadDataTwoToMuxStart
            break;
        case StartState.exIdReadDataTwoToMuxEndStarted:
            startName = TouchPointNames.exIdReadDataTwoToMuxEnd
            break;
        case StartState.exMuxToAluStartStarted:
            startName = TouchPointNames.exMuxToAluStart
            break;
        case StartState.exMuxToAluEndStarted:
            startName = TouchPointNames.exMuxToAluEnd
            break;
        default:
            startName = ""
            break;
        }

        // Set touch points incorrect...
        var tpStart: TouchPointView?
        var tpEnd: TouchPointView?
        touchPoints.forEach { tp in
            if (tp.name == startName) {
                tp.setIncorrect()
                tpStart = tp
            }

            if (tp.name == endName) {
                tp.setIncorrect()
                tpEnd = tp
            }
        }

        // ...then reset after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            tpStart?.reset()
            tpEnd?.reset()
        }
    }

    func handleTouchesBegan(
            _ touches: Set<UITouch>,
            with event: UIEvent?,
            touchPoints: [TouchPointView],
            view: UIView) {
        if let touch = touches.first {
            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch (touchPoint.name) {
                    case TouchPointNames.exIdAddToAddStart:
                        self.startState = StartState.exIdAddToAddStartStarted
                        break;
                    case TouchPointNames.exIdAddToAddEnd:
                        self.startState = StartState.exIdAddToAddEndStarted
                        break;
                    case TouchPointNames.exShiftLeftToAddStart:
                        self.startState = StartState.exShiftLeftToAddStartStarted
                        break;
                    case TouchPointNames.exShiftLeftToAddEnd:
                        self.startState = StartState.exShiftLeftToAddEndStarted
                        break;
                    case TouchPointNames.exAluToMemStart:
                        self.startState = StartState.exAluToMemStartStarted
                        break;
                    case TouchPointNames.exAluToMemEnd:
                        self.startState = StartState.exAluToMemEndStarted
                        break;
                    case TouchPointNames.exIdSignExtendToShiftLeftStart:
                        self.startState = StartState.exIdSignExtendToShiftLeftStartStarted
                        break;
                    case TouchPointNames.exIdSignExtendToShiftLeftEnd:
                        self.startState = StartState.exIdSignExtendToShiftLeftEndStarted
                        break;
                    case TouchPointNames.exIdSignExtendToMuxEnd:
                        self.startState = StartState.exIdSignExtendToMuxEndStarted
                        break;
                    case TouchPointNames.exIdReadDataOneToAluStart:
                        self.startState = StartState.exIdReadDataOneToAluStartStarted
                        break;
                    case TouchPointNames.exIdReadDataOneToAluEnd:
                        self.startState = StartState.exIdReadDataOneToAluEndStarted
                        break;
                    case TouchPointNames.exIdReadDataTwoToMuxStart:
                        self.startState = StartState.exIdReadDataTwoToMuxStartStarted
                        break;
                    case TouchPointNames.exIdReadDataTwoToMuxEnd:
                        self.startState = StartState.exIdReadDataTwoToMuxEndStarted
                        break;
                    case TouchPointNames.exMuxToAluStart:
                        self.startState = StartState.exMuxToAluStartStarted
                        break;
                    case TouchPointNames.exMuxToAluEnd:
                        self.startState = StartState.exMuxToAluEndStarted
                        break;
                    default:
                        break;
                    }
                    touchStartedInTouchPoint = true
                }
            }

            if (touchStartedInTouchPoint) {
                isDrawing = true
                lastPoint = touch.location(in: view)
                firstPoint = lastPoint
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
        // Only do anything if a touch began inside of a touch point
        if (touchStartedInTouchPoint) {
            // Get the touch
            if let touch = touches.first {

                // Set to current point
                let currentPoint = touch.location(in: view)

                // Draw the line
                drawingService.drawLineFrom(
                        fromPoint: self.lastPoint,
                        toPoint: currentPoint,
                        imageView: imageView,
                        view: view)

                // Set the last point
                lastPoint = currentPoint

                // Handle a drag from a start point to an end point
                touchPoints.forEach { touchPoint in
                    var handleDrawingOnHitTest = false
                    if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                        switch touchPoint.name {
                        case TouchPointNames.exIdAddToAddStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.exIdAddToAddStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdAddToAddStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdAddToAddEnd:
                            if (self.startState == StartState.exIdAddToAddStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exIdAddToAddEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exIdAddToAddEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdAddToAddEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exShiftLeftToAddStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.exShiftLeftToAddStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exShiftLeftToAddStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exShiftLeftToAddEnd:
                            if (self.startState == StartState.exShiftLeftToAddStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exShiftLeftToAddEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exShiftLeftToAddEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exShiftLeftToAddEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exAluToMemStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.exAluToMemStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exAluToMemStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exAluToMemEnd:
                            if (self.startState == StartState.exAluToMemStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exAluToMemEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exAluToMemEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exAluToMemEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdSignExtendToShiftLeftStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.exIdSignExtendToShiftLeftStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdSignExtendToShiftLeftStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdSignExtendToShiftLeftEnd:
                            if (self.startState == StartState.exIdSignExtendToShiftLeftStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exIdSignExtendToShiftLeftEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exIdSignExtendToShiftLeftEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdSignExtendToShiftLeftEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdSignExtendToMuxEnd:
                            if (self.startState == StartState.exIdSignExtendToShiftLeftStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exIdSignExtendToMuxEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exIdSignExtendToMuxEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdSignExtendToMuxEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdReadDataOneToAluStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.exIdReadDataOneToAluStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdReadDataOneToAluStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdReadDataOneToAluEnd:
                            if (self.startState == StartState.exIdReadDataOneToAluStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exIdReadDataOneToAluEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exIdReadDataOneToAluEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdReadDataOneToAluEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdReadDataTwoToMuxStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.exIdReadDataTwoToMuxStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdReadDataTwoToMuxStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exIdReadDataTwoToMuxEnd:
                            if (self.startState == StartState.exIdReadDataTwoToMuxStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exIdReadDataTwoToMuxEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exIdReadDataTwoToMuxEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exIdReadDataTwoToMuxEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exMuxToAluStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.exMuxToAluStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exMuxToAluStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.exMuxToAluEnd:
                            if (self.startState == StartState.exMuxToAluStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.exMuxToAluEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.exMuxToAluEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.exMuxToAluEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        default:
                            // Do nothing
                            break;
                        }
                        if (handleDrawingOnHitTest) {
                            drawingService.ignoreTouchInput()
                            drawingService.clearDrawing(imageView: imageView)
                        }
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
