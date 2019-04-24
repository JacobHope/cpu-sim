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
    case noneStarted
}

class ALUMemoryAccessStateService: State {
    var isDrawing: Bool = false
    
    var correctnessMap: [String: Bool] = [:]
    
    private var touchStartedInTouchPoint: Bool = false
    
    private var startState: StartState = StartState.noneStarted
    
    private var firstPoint = CGPoint.zero
    private var lastPoint = CGPoint.zero
    
    func resetState() {
        startState = StartState.noneStarted
        touchStartedInTouchPoint = false
        isDrawing = false
    }
    
    func handleTouchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?,
        touchPoints: [TouchPointView],
        view: UIView) {
        
    }
    
    func handleTouchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?,
        imageView: UIImageView,
        view: UIView,
        withDrawing drawingService: Drawing,
        touchPoints: [TouchPointView],
        lines: [String : [LineView]]) {
        
    }
    
    func handleTouchesEnded() {
        
    }
    
    func handleTouchesCancelled(withDrawing drawingService: Drawing) {
        
    }
}
