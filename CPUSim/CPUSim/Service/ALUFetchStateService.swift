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

// todo: rename StateService to ALUFetchStateService
private enum StartState {
    case ifMuxToPcStartStarted
    case ifMuxToPcEndStarted
    case ifPcToAluStartStarted
    case ifPcToAluEndStarted
    case ifPcToImEndStarted
    case noneStarted
}

private enum EndState {
    case ifMuxToPcStartEnded
    case ifMuxToPcEndEnded
    case ifPcToAluStartEnded
    case ifPcToAluEndEnded
    case ifPcToImEndEnded
    case noneReached
}

class ALUFetchStateService: State {
    var isDrawing: Bool = false

    var correctnessMap: [String: Bool] = [
        CorrectnessMapKeys.ifMuxToPc: false,
        CorrectnessMapKeys.ifPcToAlu: false,
        CorrectnessMapKeys.ifPcToIm: false
    ]

    private var touchStartedInTouchPoint: Bool = false

    private var startState: StartState = StartState.noneStarted
    private var endState: EndState = EndState.noneReached

    private var firstPoint = CGPoint.zero
    private var lastPoint = CGPoint.zero

    func resetState() {
        startState = StartState.noneStarted
        endState = EndState.noneReached
        touchStartedInTouchPoint = false
        isDrawing = false
    }

    private func onCorrect(
            _ touchPoints: [TouchPointView],
            touchPointName: String,
            lines: [LineView]) {

        // Set touch point correct...
        switch touchPointName {
        case "ifMuxToPcEnd":
            correctnessMap[CorrectnessMapKeys.ifMuxToPc] = true
            touchPoints.forEach { tp in
                if (tp.name == "ifMuxToPcEnd") {
                    tp.setCorrect()
                }
            }
            break;
        case "ifPcToAluEnd":
            correctnessMap[CorrectnessMapKeys.ifPcToAlu] = true
            touchPoints.forEach { tp in
                if (tp.name == "ifPcToAluEnd") {
                    tp.setCorrect()
                }
            }
        case "ifPcToImEnd":
            correctnessMap[CorrectnessMapKeys.ifPcToIm] = true
            touchPoints.forEach { tp in
                if (tp.name == "ifPcToImEnd") {
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
            case "ifMuxToPcEnd":
                touchPoints.forEach { tp in
                    if (tp.name == "ifMuxToPcEnd"
                            || tp.name == "ifMuxToPcStart") {
                        tp.isHidden = true
                    }
                }
                break;
            case "ifPcToAluEnd":
                touchPoints.forEach { tp in
                    if (tp.name == "ifPcToAluEnd") {
                        tp.isHidden = true
                    }
                    
                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.ifPcToAlu] == true
                        && self.correctnessMap[CorrectnessMapKeys.ifPcToIm] == true
                        && tp.name == "ifPcToAluStart") {
                        tp.isHidden = true
                    }
                }
                break;
            case "ifPcToImEnd":
                touchPoints.forEach { tp in
                    if (tp.name == "ifPcToImEnd") {
                        tp.isHidden = true
                    }
                    
                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.ifPcToAlu] == true
                        && self.correctnessMap[CorrectnessMapKeys.ifPcToIm] == true
                        && tp.name == "ifPcToAluStart") {
                        tp.isHidden = true
                    }
                }
                break;
            default:
                break;
            }

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

    private func onIncorrect(_ touchPoint: TouchPointView) {
        // Set touch point incorrect...
        touchPoint.setIncorrect()

        // ...then reset after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            touchPoint.reset()
        }
    }
    
    private func determineProgress() -> Float {
        var progress: Float = 0
        let total: Float = correctnessMap.count == 0 ? 1 : Float(correctnessMap.count)
        for (_,v) in correctnessMap {
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
                    case "ifMuxToPcStart":
                        self.startState = StartState.ifMuxToPcStartStarted
                        break;
                    case "ifMuxToPcEnd":
                        self.startState = StartState.ifMuxToPcEndStarted
                        break;
                    case "ifPcToAluStart":
                        self.startState = StartState.ifPcToAluStartStarted
                        break;
                    case "ifPcToAluEnd":
                        self.startState = StartState.ifPcToAluEndStarted
                        break;
                    case "ifPcToImEnd":
                        self.startState = StartState.ifPcToImEndStarted
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

        if (touchStartedInTouchPoint) {
            if let touch = touches.first {
                let currentPoint = touch.location(in: view)
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
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: "ifMuxToPcEnd",
                                        lines: lines[CorrectnessMapKeys.ifMuxToPc]!)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifMuxToPcEndStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case "ifPcToAluStart":   // Anything ending at a start point is incorrect
                            if (startState != StartState.ifPcToAluStartStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case "ifPcToAluEnd":
                            if (self.startState == StartState.ifPcToAluStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: "ifPcToAluEnd",
                                    lines: [])  // TODO
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifPcToAluEndStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case "ifPcToImEnd":
                            if (self.startState == StartState.ifPcToAluStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: "ifPcToImEnd",
                                    lines: [])  // TODO
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifPcToImEndStarted) {
                                self.onIncorrect(touchPoint)
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
