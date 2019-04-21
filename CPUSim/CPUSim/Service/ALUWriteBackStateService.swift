//
//  ALUWriteBackStateService.swift
//  CPUSim
//
//  Created by Connor Reid on 4/21/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit

class ALUWriteBackStateService: State {
    var isDrawing: Bool = false
    
    var correctnessMap: [String : Bool] = [:]
    
    func resetState() {
        
    }
    
    func handleTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, touchPoints: [TouchPointView], view: UIView) {
        
    }
    
    func handleTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, imageView: UIImageView, view: UIView, withDrawing drawingService: Drawing, touchPoints: [TouchPointView], lines: [String : [LineView]]) {
        
    }
    
    func handleTouchesEnded() {
        
    }
    
    func handleTouchesCancelled(withDrawing drawingService: Drawing) {
        
    }
}
