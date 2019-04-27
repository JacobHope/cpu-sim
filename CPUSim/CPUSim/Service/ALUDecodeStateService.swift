//
//  File.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/20/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation

import UIKit
import SwiftEventBus

//MARK: - ID Start States
private enum StartState {
    case idIfStartStarted
    case idIfToReadAddress1EndStarted
    case idIfToReadAddress2EndStarted
    case idIfToMux0EndStarted
    case idIfToMux1EndStarted
    case idIfToSignExtendStartStarted
    case idIfToSignExtendEndStarted
    case idMuxToWriteAddressStartStarted
    case idMuxToWriteAddressEndStarted
    case idExToWriteDataStartStarted
    case idExToWriteDataEndStarted
    case idSignExtendToExStartStarted
    case idSignExtendToExEndStarted
    case idReadData1ToExStartStarted
    case idReadData1ToExEndStarted
    case idReadData2ToExStartStarted
    case idReadData2ToExEndStarted
    case noneStarted
}

class ALUDecodeStateService: State {
    
    var isDrawing: Bool = false
    
    var correctnessMap: [String: Bool] = [
        CorrectnessMapKeys.idIfToEx: false,
        CorrectnessMapKeys.idIfToReadAddress1: false,
        CorrectnessMapKeys.idIfToReadAddress2: false,
        CorrectnessMapKeys.idIfToMux1: false,
        CorrectnessMapKeys.idIfToMux0: false,
        CorrectnessMapKeys.idMuxToWriteAddress: false,
        CorrectnessMapKeys.idExToWriteData: false,
        CorrectnessMapKeys.idIfToSignExtend: false,
        CorrectnessMapKeys.idSignExtendToEx: false,
        CorrectnessMapKeys.idReadData1ToEx: false,
        CorrectnessMapKeys.idReadData2ToEx: false
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

    //TODO special and missing cases still need be implemented in onCorrect...
    private func onCorrect(
        _ touchPoints: [TouchPointView],
        touchPointName: String,
        linesMap: [String: [LineView]]) {
        
        // Set touch point correct...
        switch touchPointName {
        case TouchPointNames.idExToWriteDataEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idExToWriteData] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idExToWriteDataEnd
                        || tp.name == TouchPointNames.idExToWriteDataStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idIfToReadAddress1End:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToReadAddress1] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToReadAddress1End
                        || tp.name == TouchPointNames.idIfToReadAddress1Start) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idIfToReadAddress2End:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToReadAddress2] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToReadAddress2End
                        || tp.name == TouchPointNames.idIfToReadAddress2Start) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idIfToMux0End:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToMux0] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToMux0End
                        || tp.name == TouchPointNames.idIfStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idIfToMux1End:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToMux1] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToMux1End
                        || tp.name == TouchPointNames.idIfStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idSignExtendToExEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idSignExtendToEx] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idSignExtendToExEnd
                        || tp.name == TouchPointNames.idSignExtendToExStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idMuxToWriteAddressEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToMux1] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToMux1End
                        || tp.name == TouchPointNames.idIfStart) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idIfToSignExtendEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToSignExtend] = true

            // Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToSignExtendEnd
                        || tp.name == TouchPointNames.idIfStart) {
                    tp.setCorrect()
                }
            }
            break;
        //TODO: Add remaining touch point name cases and implement them...
        default:
            break;
        }
        
        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Hide touch points
            switch touchPointName {
            case TouchPointNames.idExToWriteDataEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idExToWriteDataEnd
                            || tp.name == TouchPointNames.idExToWriteDataStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.idIfToReadAddress1End:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idIfToReadAddress1End) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress2] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux0] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToSignExtend] == true
                            && tp.name == TouchPointNames.idIfStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.idIfStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.idIfToReadAddress2End:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idIfToReadAddress2End) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress2] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux0] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToSignExtend] == true
                            && tp.name == TouchPointNames.idIfStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.idIfStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.idIfToMux0End:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idIfToMux0End) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress2] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux0] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToSignExtend] == true
                            && tp.name == TouchPointNames.idIfStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.idIfStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.idIfToMux1End:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idIfToMux1End) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress2] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux0] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToSignExtend] == true
                            && tp.name == TouchPointNames.idIfStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.idIfStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.idIfToSignExtendEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idIfToSignExtendEnd) {
                        tp.isHidden = true
                    }

                    // Special case
                    if (self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToReadAddress2] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux0] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToMux1] == true
                            && self.correctnessMap[CorrectnessMapKeys.idIfToSignExtend] == true
                            && tp.name == TouchPointNames.idIfStart) {
                        tp.isHidden = true
                    } else if (tp.name == TouchPointNames.idIfStart) {
                        tp.reset()
                    }
                }
                break;
            case TouchPointNames.idIfToEx:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == touchPointNames.idIfToExEnd
                       || tp.name == touchPointNames.idIfToExStart) {
                        tp.isHidden = true
                    }
                }
            case TouchPointNames.idSignExtendToExEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idSignExtendToExEnd
                            || tp.name == TouchPointNames.idSignExtendToExStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.idMuxToWriteAddressEnd:
                touchPoints.forEach { tp in
                    // Set hidden
                    if (tp.name == TouchPointNames.idMuxToWriteAddressEnd
                            || tp.name == TouchPointNames.idMuxToWriteAddressStart) {
                        tp.isHidden = true
                    }
                }
                break;
            case TouchPointNames.idReadData1ToExEnd:
                // Set hidden
                if (tp.name == TouchPointNames.idReadData1ToExEnd
                        || tp.name == TouchPointNames.idReadData1ToExStart) {
                    tp.isHidden = true
                }
            case TouchPointNames.idReadData2ToExEnd:
                // Set hidden
                if (tp.name == TouchPointNames.idReadData2ToExEnd
                        || tp.name == TouchPointNames.idReadData2ToExStart) {
                    tp.isHidden = true
                }
            default:
                break;
            }
            
            // Animate lines
            LineView.animateLines(
                linesMap[touchPointName] ?? [],
                duration: 0.75)
        }
        
        // Post event...
        SwiftEventBus.post(Events.aluDecodeOnCorrect, sender: determineProgress())
    }
    
    private func onIncorrect(
        _ touchPoints: [TouchPointView],
        touchPointName: String) {
        
        let startName: String
        let endName = touchPointName

        switch startState {
        case StartState.idIfStartStarted:
            startName = TouchPointNames.idIfStart
            break
        case StartState.idIfToReadAddress1EndStarted:
            startName = TouchPointNames.idIfToReadAddress1End
            break
        case StartState.idIfToReadAddress2EndStarted:
            startName = TouchPointNames.idIfToReadAddress2End
            break
        case StartState.idIfToMux0EndStarted:
            startName = TouchPointNames.idIfToMux0End
            break
        case StartState.idIfToMux1EndStarted:
            startName = TouchPointNames.idIfToMux1End
            break
        case StartState.idIfToSignExtendStartStarted:
            startName = TouchPointNames.idIfToSignExtendStart
            break
        case StartState.idIfToSignExtendEndStarted:
            startName = TouchPointNames.idIfToSignExtendEnd
            break
        case StartState.idMuxToWriteAddressStartStarted:
            startName = TouchPointNames.idMuxToWriteAddressStart
            break
        case StartState.idMuxToWriteAddressEndStarted:
            startName = TouchPointNames.idMuxToWriteAddressEnd
            break
        case StartState.idExToWriteDataStartStarted:
            startName = TouchPointNames.idExToWriteDataStart
            break
        case StartState.idExToWriteDataEndStarted:
            startName = TouchPointNames.idExToWriteDataEnd
            break
        case StartState.idSignExtendToExStartStarted:
            startName = TouchPointNames.idSignExtendToExStart
            break
        case StartState.idSignExtendToExEndStarted:
            startName = TouchPointNames.idSignExtendToExEnd
            break
        case StartState.idReadData1ToExStartStarted:
            startName = TouchPointNames.idReadData1ToExStart
            break
        case StartState.idReadData1ToExEndStarted:
            startName = TouchPointNames.idReadData1ToExEnd
            break
        case StartState.idReadData2ToExStartStarted:
            startName = TouchPointNames.idReadData2ToExStart
            break
        case StartState.idReadData2ToExEndStarted:
            startName = TouchPointNames.idReadData2ToExEnd
            break
        default:
            startName = ""
            break
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

    //TODO implement handle touches began
    func handleTouchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?,
        touchPoints: [TouchPointView],
        view: UIView) {
        
        if let touch = touches.first {
            touchPoints.forEach { touchPoint in
                if (touchPoint == touchPoint.hitTest(touch, event: event)) {
                    switch (touchPoint.name) {
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

    //TODO implement handle touches moved
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
                        //TODO: Add cases
                        default:
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


/*
switch startState {
        case idIfStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idIfToReadAddress1EndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idIfToReadAddress2EndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idIfToMux0EndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idIfToMux1EndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idIfToSignExtendStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idIfToSignExtendEndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idMuxToWriteAddressStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idMuxToWriteAddressEndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idExToWriteDataStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idExToWriteDataEndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idSignExtendToExStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idSignExtendToExEndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idReadData1ToExStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idReadData1ToExEndStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idReadData2ToExStartStarted:
            self.startState = StartState.idIfStartStarted
            break
        case idReadData2ToExEndStarted:
            self.startState = StartState.idIfStartStarted
            break
        default:
            break
        }*/