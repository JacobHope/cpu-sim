//
//  ALUFetchStateService.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import PromiseKit
import PMKUIKit
import SwiftEventBus

private enum StartState {
    case ifMuxToPcStartStarted
    case ifMuxToPcEndStarted
    case ifPcToAluStartStarted
    case ifPcToAluEndStarted
    case ifPcToImEndStarted
    case ifFourToAluStartStarted
    case ifFourToAluEndStarted
    case ifAluToMuxStartStarted
    case ifAluToMuxEndStarted
    case noneStarted
}

class ALUFetchStateService: State {
    var isDrawing: Bool = false

    var correctnessMap: [String: Bool] = [
        CorrectnessMapKeys.ifMuxToPc: false,
        CorrectnessMapKeys.ifPcToAlu: false,
        CorrectnessMapKeys.ifPcToIm: false,
        CorrectnessMapKeys.ifFourToAlu: false,
        CorrectnessMapKeys.ifAluToMux: false
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
        case TouchPointNames.ifMuxToPcEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.ifMuxToPc] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifMuxToPcEnd
                        || tp.name == TouchPointNames.ifMuxToPcStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.ifPcToAluEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.ifPcToAlu] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifPcToAluEnd
                        || tp.name == TouchPointNames.ifPcToAluStart) {
                    tp.setCorrect()
                }
            }
        case TouchPointNames.ifPcToImEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.ifPcToIm] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifPcToImEnd
                        || tp.name == TouchPointNames.ifPcToAluStart) {
                    tp.setCorrect()
                }
            }
        case TouchPointNames.ifFourToAluEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.ifFourToAlu] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifFourToAluEnd
                        || tp.name == TouchPointNames.ifFourToAluStart) {
                    tp.setCorrect()
                }
            }
        case TouchPointNames.ifAluToMuxEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.ifAluToMux] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifAluToMuxEnd
                        || tp.name == TouchPointNames.ifAluToMuxStart) {
                    tp.setCorrect()
                }
            }
        default:
            break;
        }

        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Hide touch points
            switch touchPointName {
            case TouchPointNames.ifMuxToPcEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.ifMuxToPcEnd
                            || tp.name == TouchPointNames.ifMuxToPcStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.ifPcToAluEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.ifPcToAluEnd) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.ifPcToAlu] == true
                            && self.correctnessMap[CorrectnessMapKeys.ifPcToIm] == true
                            && tp.name == TouchPointNames.ifPcToAluStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.ifPcToAluStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.ifPcToImEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.ifPcToImEnd) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.ifPcToAlu] == true
                            && self.correctnessMap[CorrectnessMapKeys.ifPcToIm] == true
                            && tp.name == TouchPointNames.ifPcToAluStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.ifPcToAluStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.ifFourToAluEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.ifFourToAluEnd
                            || tp.name == TouchPointNames.ifFourToAluStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.ifAluToMuxEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.ifAluToMuxEnd
                            || tp.name == TouchPointNames.ifAluToMuxStart) {
                        tp.isHidden = true
                    }
                }
                break;
            default:
                break;
            }

            // Get lines for touch point
            let lines: [LineView] = linesMap[touchPointName] ?? []
            
            // Animate each line in sequence
            var animate = Guarantee()
            for line in lines {
                animate = animate.then {
                    UIView.animate(.promise, duration: 0.75) {
                        line.alpha = 1.0
                    }.asVoid()
                }
            }
        }

        // Post event...
        SwiftEventBus.post(Events.aluFetchOnCorrect, sender: determineProgress())
    }

    private func onIncorrect(
            _ touchPoints: [TouchPointView],
            touchPointName: String) {

        let startName: String
        let endName = touchPointName

        switch startState {
        case StartState.ifMuxToPcStartStarted:
            startName = TouchPointNames.ifMuxToPcStart
            break;
        case StartState.ifMuxToPcEndStarted:
            startName = TouchPointNames.ifMuxToPcEnd
            break;
        case StartState.ifPcToAluStartStarted:
            startName = TouchPointNames.ifPcToAluStart
            break;
        case StartState.ifPcToAluEndStarted:
            startName = TouchPointNames.ifPcToAluEnd
            break;
        case StartState.ifPcToImEndStarted:
            startName = TouchPointNames.ifPcToImEnd
            break;
        case StartState.ifFourToAluStartStarted:
            startName = TouchPointNames.ifFourToAluStart
            break;
        case StartState.ifFourToAluEndStarted:
            startName = TouchPointNames.ifFourToAluEnd
            break;
        case StartState.ifAluToMuxStartStarted:
            startName = TouchPointNames.ifAluToMuxStart
            break;
        case StartState.ifAluToMuxEndStarted:
            startName = TouchPointNames.ifAluToMuxEnd
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
                    case TouchPointNames.ifMuxToPcStart:
                        self.startState = StartState.ifMuxToPcStartStarted
                        break;
                    case TouchPointNames.ifMuxToPcEnd:
                        self.startState = StartState.ifMuxToPcEndStarted
                        break;
                    case TouchPointNames.ifPcToAluStart:
                        self.startState = StartState.ifPcToAluStartStarted
                        break;
                    case TouchPointNames.ifPcToAluEnd:
                        self.startState = StartState.ifPcToAluEndStarted
                        break;
                    case TouchPointNames.ifPcToImEnd:
                        self.startState = StartState.ifPcToImEndStarted
                        break;
                    case TouchPointNames.ifFourToAluStart:
                        self.startState = StartState.ifFourToAluStartStarted
                        break;
                    case TouchPointNames.ifFourToAluEnd:
                        self.startState = StartState.ifFourToAluEndStarted
                        break;
                    case TouchPointNames.ifAluToMuxStart:
                        self.startState = StartState.ifAluToMuxStartStarted
                        break;
                    case TouchPointNames.ifAluToMuxEnd:
                        self.startState = StartState.ifAluToMuxEndStarted
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
                    if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                        switch touchPoint.name {
                        case TouchPointNames.ifMuxToPcStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.ifMuxToPcStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifMuxToPcStart)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifMuxToPcEnd:
                            if (self.startState == StartState.ifMuxToPcStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.ifMuxToPcEnd,
                                        linesMap: lines)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifMuxToPcEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifMuxToPcEnd)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifPcToAluStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.ifPcToAluStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifPcToAluStart)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifPcToAluEnd:
                            if (self.startState == StartState.ifPcToAluStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.ifPcToAluEnd,
                                        linesMap: lines)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifPcToAluEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifPcToAluEnd)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifPcToImEnd:
                            if (self.startState == StartState.ifPcToAluStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.ifPcToImEnd,
                                        linesMap: lines)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifPcToImEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifPcToImEnd)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                        case TouchPointNames.ifFourToAluStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.ifFourToAluStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifFourToAluStart)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifFourToAluEnd:
                            if (self.startState == StartState.ifFourToAluStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.ifFourToAluEnd,
                                        linesMap: lines)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifFourToAluEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifFourToAluEnd)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                        case TouchPointNames.ifAluToMuxStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.ifAluToMuxStartStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifAluToMuxStart)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifAluToMuxEnd:
                            if (self.startState == StartState.ifAluToMuxStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.ifAluToMuxEnd,
                                        linesMap: lines)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifAluToMuxEndStarted) {
                                self.onIncorrect(touchPoints,
                                        touchPointName: TouchPointNames.ifAluToMuxEnd)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                        default:
                            // Do nothing
                            break;
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
