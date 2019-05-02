//
//  ALUWriteBackStateService.swift
//  CPUSim
//
//  Created by Connor Reid on 4/21/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit
import SwiftEventBus

private enum StartState {
    case wbMemReadDataToMuxStartStarted
    case wbMemReadDataToMuxEndStarted
    case wbMemAddressToMuxStartStarted
    case wbMemAddressToMuxEndStarted
    case wbMemToIfWriteAddressStartStarted
    case wbMemToIfWriteAddressEndStarted
    case wbMuxtoIfWriteDataStartStarted
    case wbMuxtoIfWriteDataEndStarted
    case noneStarted
}

class ALUWriteBackStateService: State {
    var isDrawing: Bool = false
    
    var correctnessMap: [String : Bool] = [
        CorrectnessMapKeys.wbMemReadDataToMux: false,
        CorrectnessMapKeys.wbMemAddressToMux: false,
//        CorrectnessMapKeys.wbMemToIfWriteAddress: false,
        CorrectnessMapKeys.wbMuxToIfWriteData: false
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
        case TouchPointNames.wbMemReadDataToMuxEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.wbMemReadDataToMux] = true
            
            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.wbMemReadDataToMuxEnd
                    || tp.name == TouchPointNames.wbMemReadDataToMuxStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.wbMemAddressToMuxEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.wbMemAddressToMux] = true
            
            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.wbMemAddressToMuxEnd
                    || tp.name == TouchPointNames.wbMemAddressToMuxStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.wbMemToIfWriteAddressEnd:
            // Set correctnessMap
//            correctnessMap[CorrectnessMapKeys.wbMemToIfWriteAddress] = true
            
            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.wbMemToIfWriteAddressEnd
                    || tp.name == TouchPointNames.wbMemToIfWriteAddressStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.wbMuxToIfWriteDataEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.wbMuxToIfWriteData] = true
            
            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.wbMuxToIfWriteDataEnd
                    || tp.name == TouchPointNames.wbMuxToIfWriteDataStart) {
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
            case TouchPointNames.wbMemReadDataToMuxEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.wbMemReadDataToMuxEnd
                        || tp.name == TouchPointNames.wbMemReadDataToMuxStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.wbMemAddressToMuxEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.wbMemAddressToMuxEnd
                        || tp.name == TouchPointNames.wbMemAddressToMuxStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.wbMemToIfWriteAddressEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.wbMemToIfWriteAddressEnd
                        || tp.name == TouchPointNames.wbMemToIfWriteAddressStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.wbMuxToIfWriteDataEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.wbMuxToIfWriteDataEnd
                        || tp.name == TouchPointNames.wbMuxToIfWriteDataStart) {
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
        SwiftEventBus.post(Events.aluWriteBackOnCorrect, sender: determineProgress())
    }
    
    private func onIncorrect(
        _ touchPoints: [TouchPointView],
        touchPointName: String) {
        
        let startName: String
        let endName = touchPointName
        
        switch startState {
        case StartState.wbMemReadDataToMuxStartStarted:
            startName = TouchPointNames.wbMemReadDataToMuxStart
            break;
        case StartState.wbMemReadDataToMuxEndStarted:
            startName = TouchPointNames.wbMemReadDataToMuxEnd
            break;
        case StartState.wbMemAddressToMuxStartStarted:
            startName = TouchPointNames.wbMemAddressToMuxStart
            break;
        case StartState.wbMemAddressToMuxEndStarted:
            startName = TouchPointNames.wbMemAddressToMuxEnd
            break;
        case StartState.wbMemToIfWriteAddressStartStarted:
            startName = TouchPointNames.wbMemToIfWriteAddressStart
            break;
        case StartState.wbMemToIfWriteAddressEndStarted:
            startName = TouchPointNames.wbMemToIfWriteAddressEnd
            break;
        case StartState.wbMuxtoIfWriteDataStartStarted:
            startName = TouchPointNames.wbMuxToIfWriteDataStart
            break;
        case StartState.wbMuxtoIfWriteDataEndStarted:
            startName = TouchPointNames.wbMuxToIfWriteDataEnd
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
                    case TouchPointNames.wbMemReadDataToMuxStart:
                        self.startState = StartState.wbMemReadDataToMuxStartStarted
                        break;
                    case TouchPointNames.wbMemReadDataToMuxEnd:
                        self.startState = StartState.wbMemReadDataToMuxEndStarted
                        break;
                    case TouchPointNames.wbMemAddressToMuxStart:
                        self.startState = StartState.wbMemAddressToMuxStartStarted
                        break;
                    case TouchPointNames.wbMemAddressToMuxEnd:
                        self.startState = StartState.wbMemAddressToMuxEndStarted
                        break;
                    case TouchPointNames.wbMemToIfWriteAddressStart:
                        self.startState = StartState.wbMemToIfWriteAddressStartStarted
                        break;
                    case TouchPointNames.wbMemToIfWriteAddressEnd:
                        self.startState = StartState.wbMemToIfWriteAddressEndStarted
                        break;
                    case TouchPointNames.wbMuxToIfWriteDataStart:
                        self.startState = StartState.wbMuxtoIfWriteDataStartStarted
                        break;
                    case TouchPointNames.wbMuxToIfWriteDataEnd:
                        self.startState = StartState.wbMuxtoIfWriteDataEndStarted
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
        lines: [String : [LineView]]) {
        
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
                        case TouchPointNames.wbMemReadDataToMuxStart:  // Anything ending at a start point is incorrect
                            if (startState != StartState.wbMemReadDataToMuxStartStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMemReadDataToMuxStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMemReadDataToMuxEnd:
                            if (self.startState == StartState.wbMemReadDataToMuxStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: TouchPointNames.wbMemReadDataToMuxEnd,
                                    linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.wbMemReadDataToMuxEndStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMemReadDataToMuxEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMemAddressToMuxStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.wbMemAddressToMuxStartStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMemAddressToMuxStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMemAddressToMuxEnd:
                            if (self.startState == StartState.wbMemAddressToMuxStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: TouchPointNames.wbMemAddressToMuxEnd,
                                    linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.wbMemAddressToMuxEndStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMemAddressToMuxEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMemToIfWriteAddressStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.wbMemToIfWriteAddressStartStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMemToIfWriteAddressStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMemToIfWriteAddressEnd:
                            if (self.startState == StartState.wbMemToIfWriteAddressStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: TouchPointNames.wbMemToIfWriteAddressEnd,
                                    linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.wbMemToIfWriteAddressEndStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMemToIfWriteAddressEnd)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMuxToIfWriteDataStart:   // Anything ending at a start point is incorrect
                            if (startState != StartState.wbMuxtoIfWriteDataStartStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMuxToIfWriteDataStart)
                                handleDrawingOnHitTest = true
                            }
                            break;
                        case TouchPointNames.wbMuxToIfWriteDataEnd:
                            if (self.startState == StartState.wbMuxtoIfWriteDataStartStarted) {
                                self.onCorrect(
                                    touchPoints,
                                    touchPointName: TouchPointNames.wbMuxToIfWriteDataEnd,
                                    linesMap: lines)
                                handleDrawingOnHitTest = true
                            } else if (startState != StartState.wbMuxtoIfWriteDataEndStarted) {
                                self.onIncorrect(touchPoints,
                                                 touchPointName: TouchPointNames.wbMuxToIfWriteDataEnd)
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
