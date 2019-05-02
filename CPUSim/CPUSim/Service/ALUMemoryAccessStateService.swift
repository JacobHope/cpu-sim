//
//  MemoryAccessStateService.swift
//  CPUSim
//
//  Created by Connor Reid on 4/23/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit
import SwiftEventBus

private enum StartState {
    case memExToAddressStartStarted
    case memExToAddressEndStarted
    case memExToWriteDataStartStarted
    case memExToWriteDataEndStarted
    case memReadDataToWbStartStarted
    case memReadDataToWbEndStarted
    case memRegDstExToWbStartStarted
    case memRegDstExToWbEndStarted
    case memRegDstWbToExStartStarted
    case memRegDstWbToExEndStarted
    case memMemToRegWbToExStartStarted
    case memMemToRegWbToExEndStarted
    case noneStarted
}

class ALUMemoryAccessStateService: State {
    var isDrawing: Bool = false

    var correctnessMap: [String: Bool] = [
        CorrectnessMapKeys.memExToAddress: false,
        CorrectnessMapKeys.memExToWriteData: false,
        CorrectnessMapKeys.memReadDataToWb: false,
        CorrectnessMapKeys.memRegDstExToWb: false,
//        CorrectnessMapKeys.memRegDstWbToEx: false,
        CorrectnessMapKeys.memMemToRegWbToEx: false
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
        case TouchPointNames.memExToAddressEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.memExToAddress] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.memExToAddressEnd
                        || tp.name == TouchPointNames.memExToAddressStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.memExToWriteDataEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.memExToWriteData] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.memExToWriteDataEnd
                        || tp.name == TouchPointNames.memExToWriteDataStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.memReadDataToWbEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.memReadDataToWb] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.memReadDataToWbEnd
                        || tp.name == TouchPointNames.memReadDataToWbStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.memRegDstExToWbEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.memRegDstExToWb] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.memRegDstExToWbEnd
                        || tp.name == TouchPointNames.memRegDstExToWbStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.memRegDstWbToExEnd:
            // Set correctnessMap
//            correctnessMap[CorrectnessMapKeys.memRegDstWbToEx] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.memRegDstWbToExEnd
                        || tp.name == TouchPointNames.memRegDstWbToExStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.memMemToRegWbToExEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.memMemToRegWbToEx] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.memMemToRegWbToExEnd
                        || tp.name == TouchPointNames.memMemToRegWbToExStart) {
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
            case TouchPointNames.memExToAddressEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.memExToAddressEnd
                            || tp.name == TouchPointNames.memExToAddressStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.memExToWriteDataEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.memExToWriteDataEnd
                            || tp.name == TouchPointNames.memExToWriteDataStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.memReadDataToWbEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.memReadDataToWbEnd
                            || tp.name == TouchPointNames.memReadDataToWbStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.memRegDstExToWbEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.memRegDstExToWbEnd
                            || tp.name == TouchPointNames.memRegDstExToWbStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.memRegDstWbToExEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.memRegDstWbToExEnd
                            || tp.name == TouchPointNames.memRegDstWbToExStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.memMemToRegWbToExEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.memMemToRegWbToExEnd
                            || tp.name == TouchPointNames.memMemToRegWbToExStart) {
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
        SwiftEventBus.post(Events.aluMemoryAccessOnCorrect, sender: determineProgress())
    }

    private func onIncorrect(
            _ touchPoints: [TouchPointView],
            touchPointName: String) {

        let startName: String
        let endName = touchPointName

        switch startState {
        case StartState.memExToAddressStartStarted:
            startName = TouchPointNames.memExToAddressStart
            break;
        case StartState.memExToAddressEndStarted:
            startName = TouchPointNames.memExToAddressEnd
            break;
        case StartState.memExToWriteDataStartStarted:
            startName = TouchPointNames.memExToWriteDataStart
            break;
        case StartState.memExToWriteDataEndStarted:
            startName = TouchPointNames.memExToWriteDataEnd
            break;
        case StartState.memReadDataToWbStartStarted:
            startName = TouchPointNames.memReadDataToWbStart
            break;
        case StartState.memReadDataToWbEndStarted:
            startName = TouchPointNames.memReadDataToWbEnd
            break;
        case StartState.memRegDstExToWbStartStarted:
            startName = TouchPointNames.memRegDstExToWbStart
            break;
        case StartState.memRegDstExToWbEndStarted:
            startName = TouchPointNames.memRegDstExToWbEnd
            break;
        case StartState.memRegDstWbToExStartStarted:
            startName = TouchPointNames.memRegDstWbToExStart
            break;
        case StartState.memRegDstWbToExEndStarted:
            startName = TouchPointNames.memRegDstWbToExEnd
            break;
        case StartState.memMemToRegWbToExStartStarted:
            startName = TouchPointNames.memMemToRegWbToExStart
            break;
        case StartState.memMemToRegWbToExEndStarted:
            startName = TouchPointNames.memMemToRegWbToExEnd
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

    func handleTouchesBegan(
            _ touches: Set<UITouch>,
            with event: UIEvent?,
            touchPoints: [TouchPointView],
            view: UIView) {

        if let touch = touches.first {
            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch (touchPoint.name) {
                    case TouchPointNames.memExToAddressStart:
                        self.startState = StartState.memExToAddressStartStarted
                        break;
                    case TouchPointNames.memExToAddressEnd:
                        self.startState = StartState.memExToAddressEndStarted
                        break;
                    case TouchPointNames.memExToWriteDataStart:
                        self.startState = StartState.memExToWriteDataStartStarted
                        break;
                    case TouchPointNames.memExToWriteDataEnd:
                        self.startState = StartState.memExToWriteDataEndStarted
                        break;
                    case TouchPointNames.memReadDataToWbStart:
                        self.startState = StartState.memReadDataToWbStartStarted
                        break;
                    case TouchPointNames.memReadDataToWbEnd:
                        self.startState = StartState.memReadDataToWbEndStarted
                        break;
                    case TouchPointNames.memRegDstExToWbStart:
                        self.startState = StartState.memRegDstExToWbStartStarted
                        break;
                    case TouchPointNames.memRegDstExToWbEnd:
                        self.startState = StartState.memRegDstExToWbEndStarted
                        break;
                    case TouchPointNames.memRegDstWbToExStart:
                        self.startState = StartState.memRegDstWbToExStartStarted
                        break;
                    case TouchPointNames.memRegDstWbToExEnd:
                        self.startState = StartState.memRegDstWbToExEndStarted
                        break;
                    case TouchPointNames.memMemToRegWbToExStart:
                        self.startState = StartState.memMemToRegWbToExStartStarted
                        break;
                    case TouchPointNames.memMemToRegWbToExEnd:
                        self.startState = StartState.memMemToRegWbToExEndStarted
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
                        case TouchPointNames.memExToAddressStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.memExToAddressStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memExToAddressStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memExToAddressEnd:
                            if (self.startState == StartState.memExToAddressStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.memExToAddressEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.memExToAddressEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memExToAddressEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memExToWriteDataStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.memExToWriteDataStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memExToWriteDataStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memExToWriteDataEnd:
                            if (self.startState == StartState.memExToWriteDataStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.memExToWriteDataEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.memExToWriteDataEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memExToWriteDataEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memReadDataToWbStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.memReadDataToWbStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memReadDataToWbStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memReadDataToWbEnd:
                            if (self.startState == StartState.memReadDataToWbStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.memReadDataToWbEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.memReadDataToWbEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memReadDataToWbEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memRegDstExToWbStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.memRegDstExToWbStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memRegDstExToWbStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memRegDstExToWbEnd:
                            if (self.startState == StartState.memRegDstExToWbStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.memRegDstExToWbEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.memRegDstExToWbEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memRegDstExToWbEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memRegDstWbToExStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.memRegDstWbToExStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memRegDstWbToExStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memRegDstWbToExEnd:
                            if (self.startState == StartState.memRegDstWbToExStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.memRegDstWbToExEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.memRegDstWbToExEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memRegDstWbToExEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memMemToRegWbToExStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.memMemToRegWbToExStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memMemToRegWbToExStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.memMemToRegWbToExEnd:
                            if (self.startState == StartState.memMemToRegWbToExStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.memMemToRegWbToExEnd,
                                        linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.memMemToRegWbToExEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.memMemToRegWbToExEnd)
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
