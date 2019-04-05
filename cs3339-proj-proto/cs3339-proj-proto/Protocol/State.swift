//
//  State.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

protocol State {
    func resetState()
    func handleTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, inViewController viewController: ViewController)
    func handleTouchesMove(_ touches: Set<UITouch>, with event: UIEvent?, inViewController viewController: ViewController, withDrawing drawingService: Drawing)
    func handleTouchesEnded()
    func handleTouchesCancelled(withDrawing drawingService: Drawing)
}
