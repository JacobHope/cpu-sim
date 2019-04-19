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
    case if4ToAluStartStarted
    case noneStarted
}

// todo this is unused, get rid of it
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
        CorrectnessMapKeys.ifPcToIm: false,
        CorrectnessMapKeys.ifFourToAlu: false
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
        case TouchPointNames.ifMuxToPcEnd:
            correctnessMap[CorrectnessMapKeys.ifMuxToPc] = true
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifMuxToPcEnd) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.ifPcToAluEnd:
            correctnessMap[CorrectnessMapKeys.ifPcToAlu] = true
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifPcToAluEnd) {
                    tp.setCorrect()
                }
            }
        case TouchPointNames.ifPcToImEnd:
            correctnessMap[CorrectnessMapKeys.ifPcToIm] = true
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.ifPcToImEnd) {
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
                    if (tp.name == TouchPointNames.ifMuxToPcEnd
                            || tp.name == TouchPointNames.ifMuxToPcStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.ifPcToAluEnd:
                touchPoints.forEach { tp in
                    if (tp.name == TouchPointNames.ifPcToAluEnd) {
                        tp.isHidden = true
                    }
                    
                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.ifPcToAlu] == true
                        && self.correctnessMap[CorrectnessMapKeys.ifPcToIm] == true
                        && tp.name == TouchPointNames.ifPcToAluStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.ifPcToImEnd:
                touchPoints.forEach { tp in
                    if (tp.name == TouchPointNames.ifPcToImEnd) {
                        tp.isHidden = true
                    }
                    
                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.ifPcToAlu] == true
                        && self.correctnessMap[CorrectnessMapKeys.ifPcToIm] == true
                        && tp.name == TouchPointNames.ifPcToAluStart) {
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
                    case TouchPointNames.ifFourToAluStart:
                        self.startState = StartState.if4ToAluStartStarted
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
                        case TouchPointNames.ifMuxToPcStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.ifMuxToPcStartStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifMuxToPcEnd:
                            if (self.startState == StartState.ifMuxToPcStartStarted) {
                                self.onCorrect(
                                        touchPoints,
                                        touchPointName: TouchPointNames.ifMuxToPcEnd,
                                        lines: lines[CorrectnessMapKeys.ifMuxToPc]!)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifMuxToPcEndStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifPcToAluStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.ifPcToAluStartStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifPcToAluEnd:
                            if (self.startState == StartState.ifPcToAluStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: TouchPointNames.ifPcToAluEnd,
                                    lines: [])  // TODO
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifPcToAluEndStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                            break;
                        case TouchPointNames.ifPcToImEnd:
                            if (self.startState == StartState.ifPcToAluStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: TouchPointNames.ifPcToImEnd,
                                    lines: [])  // TODO
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            } else if (startState != StartState.ifPcToImEndStarted) {
                                self.onIncorrect(touchPoint)
                                drawingService.ignoreTouchInput()
                                drawingService.clearDrawing(imageView: imageView)
                            }
                        case TouchPointNames.ifFourToAluStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.if4ToAluStartStarted) {
                                self.onIncorrect(touchPoint)
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
    }

    func handleTouchesEnded() {
        self.resetState()
    }

    func handleTouchesCancelled(withDrawing drawingService: Drawing) {
        drawingService.resumeTouchInput()
        self.resetState()
    }
}