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
    case idIfToReadAddress1StartStarted
    case idIfToReadAddress1EndStarted
    case idIfToReadAddress2StartStarted
    case idIfToReadAddress2EndStarted
    //TODO: start state needed for forked path between read address and mux
    case idIfToMux0StartStarted
    case idIfToMux0EndStarted
    case idIfToMux1StartStarted
    case idIfToMux1EndStarted
    case idMuxToWriteAddressStartStarted
    case idMuxToWriteAddressEndStarted
    case idIfToSignExtendStartStarted
    case idIfToSignExtendEndStarted
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
        CorrectnessMapKeys.idIfToReadAddress1: false,
        CorrectnessMapKeys.idIfToReadAddress2: false,
        //TODO need correctness map keys for forked path between mux 0 and read addr 1.
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
                        || tp.name == TouchPointNames.idIfToMux0Start) {
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
                        || tp.name == TouchPointNames.idIfToMux1Start) {
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
                        || tp.name == TouchPointNames.idIfToMux1Start) {
                    tp.setCorrect()
                }
            }
            break;
        case TouchPointNames.idIfToSignExtendEnd:
            // Set correctnessMap
            correctnessMap[CorrectnessMapKeys.idIfToSignExtend] = true

            //TODO sign extend start doesn't exist start touch point shared...
            /* Set correct (change color to green)
            touchPoints.forEach { tp in
                if (tp.name == TouchPointNames.idIfToSignExtendEnd
                        || tp.name == TouchPointNames.idIfToSignExtendStart) {
                    tp.setCorrect()
                }
            }*/
            break;
        //TODO: Add remaining touch point name cases and implement them...
        default:
            break;
        }
        
        // ...then stop pulsating after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Hide touch points
            switch touchPointName {
            case TouchPointNames.idIfToMux0End:
                break;
                //TODO: add remaining cases and special cases
            default:
                break;
            }
            
            // Animate lines
            LineView.animateLines(
                linesMap[touchPointName] ?? [],
                duration: 0.75)
        }
        
        // Post event...
        SwiftEventBus.post(Events.aluIfOnCorrect, sender: determineProgress())
    }
    
    private func onIncorrect(
        _ touchPoints: [TouchPointView],
        touchPointName: String) {
        
        let startName: String
        let endName = touchPointName
        
        // TODO add cases
        switch startState {
        case StartState.idIfToMux0EndStarted:
            break;
        case StartState.idIfToMux1EndStarted:
            break;
        default:
            startName = ""
            break;
        }
        
        // Set touch points incorrect...
        var tpStart: TouchPointView?
        var tpEnd: TouchPointView?
        touchPoints.forEach { tp in
            //TODO uncomment below when above switch statement is implemented.
//            if (tp.name == startName) {
//                tp.setIncorrect()
//                tpStart = tp
//            }
            
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


