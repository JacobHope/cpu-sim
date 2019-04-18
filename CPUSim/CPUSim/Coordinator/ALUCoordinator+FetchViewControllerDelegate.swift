//
//  ALUCoordinator+FetchViewControllerDelegate.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/16/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation

// MARK: FetchViewControllerDelegate
extension ALUCoordinator: FetchViewControllerDelegate {
    func fetchViewControllerOnTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.fetchViewController == nil) {
            return
        }
        
        self.drawingService.clearDrawing(
            imageView: self.fetchViewController!.drawingImageView)
        
        self.fetchStateService.handleTouchesBegan(
            touches,
            with: event,
            touchPoints: self.fetchViewController!.touchPoints,
            view: self.fetchViewController!.drawingImageView)
    }
    
    func fetchViewControllerOnTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.fetchViewController == nil) {
            return
        }
        
        // todo: pass in only drawingImageView
        fetchStateService.handleTouchesMoved(
            touches,
            with: event,
            imageView: self.fetchViewController!.drawingImageView,
            view: self.fetchViewController!.drawingImageView,
            withDrawing: drawingService,
            touchPoints: self.fetchViewController!.touchPoints,
            lines: self.fetchViewController!.lines)
    }
    
    func fetchViewControllerOnTouchesEnded() {
        fetchStateService.resetState()
    }
    
    func fetchViewControllerOnTouchesCancelled() {
        drawingService.resumeTouchInput()
        fetchStateService.resetState()
    }
    
    func fetchViewControllerClearDrawing() {
        if (self.fetchViewController == nil) {
            return
        }
        drawingService.clearDrawing(imageView: self.fetchViewController!.drawingImageView)
    }
    
    func fetchViewControllerSetup() {
        self.fetchViewController?.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(
                DotModel(
                    x: -4.75,
                    y: -4.75,
                    radius: 10.0))
        }
        
        for (_, v) in self.fetchViewController!.lines {
            v.forEach { line in
                line.setup()
            }
        }
    }
    
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController) {
        if (!fetchStateService.isDrawing) {
            self.navigationController.popViewController(animated: true)
        }
    }
    
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController) {
        if (!fetchStateService.isDrawing) {
            self.showDecodeViewController()
        }
    }
    
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController) {
        self.delegate?.aluCoordinatorDidRequestCancel(aluCoordinator: self)
    }
    
    func fetchViewController(_ fetchViewController: FetchViewController) {
        //self.showDecodeViewController()
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.fetchViewController == nil) {
            return
        }
        
        // todo: pass in only drawingImageView
        fetchStateService.handleTouchesMoved(
            touches,
            with: event,
            imageView: self.fetchViewController!.drawingImageView,
            view: self.fetchViewController!.drawingImageView,
            withDrawing: drawingService,
            touchPoints: self.fetchViewController!.touchPoints,
            lines: self.fetchViewController!.lines)
    }
    
    func onTouchesEnded() {
        fetchStateService.resetState()
    }
    
    func onTouchesCancelled() {
        drawingService.resumeTouchInput()
        fetchStateService.resetState()
    }
    
    func clearDrawing() {
        if (self.fetchViewController == nil) {
            return
        }
        drawingService.clearDrawing(imageView: self.fetchViewController!.drawingImageView)
    }
    
    func setup() {
        self.fetchViewController?.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(
                DotModel(
                    x: -4.75,
                    y: -4.75,
                    radius: 10.0))
        }
        
        for (_, v) in self.fetchViewController!.lines {
            v.forEach { line in
                line.setup()
            }
        }
    }
}
