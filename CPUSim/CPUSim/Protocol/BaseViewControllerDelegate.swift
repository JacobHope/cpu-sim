//
//  ViewControllerDelegate.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/4/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit


@objc internal protocol BaseViewControllerDelegate: class {
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func onTouchesEnded()
    func onTouchesCancelled()
    func clearDrawing()
    func setup()
    //TODO add left and right swipe
}
