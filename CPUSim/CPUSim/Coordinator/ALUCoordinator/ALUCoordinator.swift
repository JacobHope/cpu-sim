//
//  ALUCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/31/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation

protocol ALUCoordinatorDelegate: class {
    func aluCoordinatorDidRequestCancel(aluCoordinator: ALUCoordinator)
    func aluCoordinator(aluCoordinator: ALUCoordinator, payload: ALUCoordinatorPayload)
}

class ALUCoordinatorPayload {
    // Data passed through the view controllers
}

class ALUCoordinator: RootViewCoordinator {
    
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    weak var delegate: ALUCoordinatorDelegate?
    var orderPayload: ALUCoordinatorPayload?
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    private let drawingService: Drawing
    private let fetchStateService: State
    private let memoryAccessStateService: State
    private let writeBackStateService: State
    
    // MARK: Init
    
    init(drawingService: Drawing,
         fetchStateService: State,
         memoryAccessStateService: State,
         writeBackStateService: State) {
        self.drawingService = drawingService
        self.fetchStateService = fetchStateService
        self.memoryAccessStateService = memoryAccessStateService
        self.writeBackStateService = writeBackStateService
    }
    
    // MARK: Functions
    
    func start() {
        self.showFetchViewController()
    }
    
    func showFetchViewController() {
        let fetchViewController = FetchViewController()
        fetchViewController.delegate = self
        self.navigationController.viewControllers = [fetchViewController]
    }
    
    func showDecodeViewController() {
         let decodeViewController = DecodeViewController()
         decodeViewController.delegate = self
         self.navigationController.pushViewController(decodeViewController, animated: true)
    }
     
    func showExecuteViewController() {
         let executeViewController = ExecuteViewController()
         executeViewController.delegate = self
         self.navigationController.pushViewController(executeViewController, animated: true)
    }
     
    func showMemoryAccessViewController() {
         let memoryAccessViewController = MemoryAccessViewController()
         memoryAccessViewController.delegate = self
         self.navigationController.pushViewController(memoryAccessViewController, animated: true)
    }
     
    func showWriteBackViewController() {
         let writeBackViewController = WriteBackViewController()
         writeBackViewController.delegate = self
         self.navigationController.pushViewController(writeBackViewController, animated: true)
    }
}


// MARK: FetchViewControllerDelegate

extension ALUCoordinator: FetchViewControllerDelegate {
    
    func fetchViewControllerOnTouchesBegan(_ fetchViewController: FetchViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        drawingService.clearDrawing(
            imageView: fetchViewController.drawingImageView)
        
        fetchStateService.handleTouchesBegan(
            touches,
            with: event,
            touchPoints: fetchViewController.touchPoints,
            view: fetchViewController.drawingImageView)
    }
    
    func fetchViewControllerOnTouchesMoved(_ fetchViewController: FetchViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        // todo: pass in only drawingImageView
        fetchStateService.handleTouchesMoved(
            touches,
            with: event,
            imageView: fetchViewController.drawingImageView,
            view: fetchViewController.drawingImageView,
            withDrawing: drawingService,
            touchPoints: fetchViewController.touchPoints,
            lines: fetchViewController.lines)
    }
    
    func fetchViewControllerOnTouchesEnded(_ fetchViewController: FetchViewController) {
        fetchStateService.resetState()
    }
    
    func fetchViewControllerOnTouchesCancelled(_ fetchViewController: FetchViewController) {
        drawingService.resumeTouchInput()
        fetchStateService.resetState()
    }
    
    func fetchViewControllerClearDrawing(_ fetchViewController: FetchViewController) {
        drawingService.clearDrawing(imageView: fetchViewController.drawingImageView)
    }
    
    func fetchViewControllerSetup(_ fetchViewController: FetchViewController) {
        // Setup ProgressView
        fetchViewController.progressView.progress = 0.0
        fetchViewController.progressView.progressTintColor = UIColor.green
        
        // Setup event subscribers
        SwiftEventBus.onMainThread(fetchViewController, name: Events.aluFetchOnCorrect) { result in
            let progress: Float = result?.object as! Float
            fetchViewController.progressView.setProgress(progress, animated: true)
            
            // If progress is complete...
            if (progress == 1) {
                // ...show complete button and animate tab bar after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    // Unhide complete button
                    fetchViewController.completeButton.isHidden = false
                    
                    // Begin complete button animation
                    UIView.beginCompleteButtonAnimation(fetchViewController.completeButton)
                    
                    // Begin tab bar animation
                    fetchViewController.ifIdTab.setStageFinished()
                }
            }
        }
        
        // Setup complete button
        fetchViewController.completeButton.isHidden = true
        
        // Setup TouchPointViews
        fetchViewController.ifMuxToPcStart.name = TouchPointNames.ifMuxToPcStart
        fetchViewController.ifMuxToPcEnd.name = TouchPointNames.ifMuxToPcEnd
        fetchViewController.ifPcToAluStart.name = TouchPointNames.ifPcToAluStart
        fetchViewController.ifPcToAluEnd.name = TouchPointNames.ifPcToAluEnd
        fetchViewController.ifPcToImEnd.name = TouchPointNames.ifPcToImEnd
        fetchViewController.ifFourToAluStart.name = TouchPointNames.ifFourToAluStart
        fetchViewController.ifFourToAluEnd.name = TouchPointNames.ifFourToAluEnd
        fetchViewController.ifAluToMuxStart.name = TouchPointNames.ifAluToMuxStart
        fetchViewController.ifAluToMuxEnd.name = TouchPointNames.ifAluToMuxEnd
        fetchViewController.ifImToIdStart.name = TouchPointNames.ifImToIdStart
        fetchViewController.ifImToIdEnd.name = TouchPointNames.ifImToIdEnd
        fetchViewController.ifAluToIdEnd.name = TouchPointNames.ifAluToIdEnd
        
        fetchViewController.touchPoints = [
            fetchViewController.ifMuxToPcStart,
            fetchViewController.ifMuxToPcEnd,
            fetchViewController.ifPcToAluStart,
            fetchViewController.ifPcToAluEnd,
            fetchViewController.ifPcToImEnd,
            fetchViewController.ifFourToAluStart,
            fetchViewController.ifFourToAluEnd,
            fetchViewController.ifAluToMuxStart,
            fetchViewController.ifAluToMuxEnd,
            fetchViewController.ifImToIdStart,
            fetchViewController.ifImToIdEnd,
            fetchViewController.ifAluToIdEnd
        ]
        
        // Setup lines
        
        // IFMUXtoPC
        fetchViewController.lines[TouchPointNames.ifMuxToPcEnd] = [
            fetchViewController.ifMuxToPc1,
            fetchViewController.ifMuxToPc2,
            fetchViewController.ifMuxToPc3
        ]
        
        // IFPCtoALU
        fetchViewController.lines[TouchPointNames.ifPcToAluEnd] = [
            fetchViewController.ifPcToAlu1,
            fetchViewController.ifPcToAlu2
        ]
        
        // IFPCtoIM
        fetchViewController.lines[TouchPointNames.ifPcToImEnd] = [
            fetchViewController.ifPcToIm1
        ]
        
        // IFFourToALU
        fetchViewController.lines[TouchPointNames.ifFourToAluEnd] = [
            fetchViewController.ifFourToAlu1
        ]
        
        // IFALUToMUX
        fetchViewController.lines[TouchPointNames.ifAluToMuxEnd] = [
            fetchViewController.ifAluToMux1,
            fetchViewController.ifAluToMux2,
            fetchViewController.ifAluToMux3
        ]
        
        // IFIMtoID
        fetchViewController.lines[TouchPointNames.ifImToIdEnd] = [
            fetchViewController.ifImToId1
        ]
        
        // IFALUToID
        fetchViewController.lines[TouchPointNames.ifAluToIdEnd] = [
            fetchViewController.ifAluToId1
        ]
        
        // Setup all touch points
        fetchViewController.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(DotModel.defaultDotModel())
        }
        
        // Setup all lines
        for (_, v) in fetchViewController.lines {
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
            // Hide complete button
            fetchViewController.completeButton.isHidden = true
            self.showDecodeViewController()
        }
    }
    
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController) {
        self.delegate?.aluCoordinatorDidRequestCancel(aluCoordinator: self)
    }
    
    func fetchViewController(_ fetchViewController: FetchViewController) {
        //self.showDecodeViewController()
    }
}

// MARK: DecodeViewControllerDelegate

extension ALUCoordinator: DecodeViewControllerDelegate {
    func decodeViewControllerDidSwipeLeft(_ decodeViewController: DecodeViewController) {
        self.navigationController.popViewController(animated: true)

        // Reset animations
        guard let tvc = self.navigationController.topViewController else {
            return
        }
        if (tvc.nibName == "FetchView") {
            let fvc: FetchViewController = tvc as! FetchViewController
            fvc.touchPoints.forEach { tp in
                if (!tp.isHidden) {
                    tp.setupWith(DotModel.defaultDotModel())
                    
                }
            }
        }
    }
    
    func decodeViewControllerDidSwipeRight(_ decodeViewController: DecodeViewController) {
        self.showExecuteViewController()
    }
    
    func decodeViewController(_ decodeViewController: DecodeViewController) {
        
    }
    
}

// MARK: ExecuteViewControllerDelegate

extension ALUCoordinator: ExecuteViewControllerDelegate {
    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController) {
        self.showMemoryAccessViewController()
    }
    
    
    func executeViewController(_ executeViewController: ExecuteViewController) {
        
    }
    
}

// MARK: MemoryAccessViewControllerDelegate

extension ALUCoordinator: MemoryAccessViewControllerDelegate {
    func memoryAccessViewControllerOnTouchesBegan(
        _ memoryAccessViewController: MemoryAccessViewController,
        _ touches: Set<UITouch>,
        with event: UIEvent?) {
        
        drawingService.clearDrawing(
            imageView: memoryAccessViewController.drawingImageView)
        
        memoryAccessStateService.handleTouchesBegan(
            touches,
            with: event,
            touchPoints: memoryAccessViewController.touchPoints,
            view: memoryAccessViewController.drawingImageView)
    }
    
    func memoryAccessViewControllerOnTouchesMoved(
        _ memoryAccessViewController: MemoryAccessViewController,
        _ touches: Set<UITouch>,
        with event: UIEvent?) {
        
        // todo: pass in only drawingImageView
        memoryAccessStateService.handleTouchesMoved(
            touches,
            with: event,
            imageView: memoryAccessViewController.drawingImageView,
            view: memoryAccessViewController.drawingImageView,
            withDrawing: drawingService,
            touchPoints: memoryAccessViewController.touchPoints,
            lines: memoryAccessViewController.lines)
    }
    
    func memoryAccessViewControllerOnTouchesEnded(
        _ memoryAccessViewController: MemoryAccessViewController) {
        memoryAccessStateService.resetState()
    }
    
    func memoryAccessViewControllerOnTouchesCancelled(
        _ memoryAccessViewController: MemoryAccessViewController) {
        drawingService.resumeTouchInput()
        memoryAccessStateService.resetState()
    }
    
    func memoryAccessViewControllerClearDrawing(
        _ memoryAccessViewController: MemoryAccessViewController) {
        drawingService.clearDrawing(imageView: memoryAccessViewController.drawingImageView)
    }
    
    func memoryAccessViewControllerSetup(
        _ memoryAccessViewController: MemoryAccessViewController) {
        
        // Setup ProgressView
        memoryAccessViewController.progressView.progress = 0.0
        memoryAccessViewController.progressView.progressTintColor = UIColor.green
        
        // Setup event subscribers
        SwiftEventBus.onMainThread(memoryAccessViewController, name: Events.aluMemoryAccessOnCorrect) { result in
            let progress: Float = result?.object as! Float
            memoryAccessViewController.progressView.setProgress(progress, animated: true)
            
            // If progress is complete...
            if (progress == 1) {
                // ...animate tab bar after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    // Begin tab bar animation
                    memoryAccessViewController.memExTab.setStageFinished()
                    memoryAccessViewController.memWbTab.setStageFinished()
                }
            }
        }
        
        // Setup TouchPointViews
        memoryAccessViewController.memExToAddressStart.name = TouchPointNames.memExToAddressStart
        memoryAccessViewController.memExToAddressEnd.name = TouchPointNames.memExToAddressEnd
        memoryAccessViewController.memExtoWriteDataStart.name = TouchPointNames.memExToWriteDataStart
        memoryAccessViewController.memExToWriteDataEnd.name = TouchPointNames.memExToWriteDataEnd
        memoryAccessViewController.memReadDataToWbStart.name = TouchPointNames.memReadDataToWbStart
        memoryAccessViewController.memReadDataToWbEnd.name = TouchPointNames.memReadDataToWbEnd
        memoryAccessViewController.memRegDstExToWbStart.name = TouchPointNames.memRegDstExToWbStart
        memoryAccessViewController.memRegDstExToWbEnd.name = TouchPointNames.memRegDstExToWbEnd
        memoryAccessViewController.memRegDstWbToExStart.name = TouchPointNames.memRegDstWbToExStart
        memoryAccessViewController.memRegDstWbToExEnd.name = TouchPointNames.memRegDstWbToExEnd
        memoryAccessViewController.memMemToRegWbToExStart.name = TouchPointNames.memMemToRegWbToExStart
        memoryAccessViewController.memMemToRegWbToExEnd.name = TouchPointNames.memMemToRegWbToExEnd
        
        memoryAccessViewController.touchPoints = [
            memoryAccessViewController.memExToAddressStart,
            memoryAccessViewController.memExToAddressEnd,
            memoryAccessViewController.memExtoWriteDataStart,
            memoryAccessViewController.memExToWriteDataEnd,
            memoryAccessViewController.memReadDataToWbStart,
            memoryAccessViewController.memReadDataToWbEnd,
            memoryAccessViewController.memRegDstExToWbStart,
            memoryAccessViewController.memRegDstExToWbEnd,
            memoryAccessViewController.memRegDstWbToExStart,
            memoryAccessViewController.memRegDstWbToExEnd,
            memoryAccessViewController.memMemToRegWbToExStart,
            memoryAccessViewController.memMemToRegWbToExEnd
        ]
        
        // Setup lines
        
        // MARK: MEMEXToAddress
        memoryAccessViewController.lines[TouchPointNames.memExToAddressEnd] = [
            memoryAccessViewController.memExToAddress1,
            memoryAccessViewController.memExToAddress2,
            memoryAccessViewController.memExToAddress3,
            memoryAccessViewController.memExToAddress4,
            memoryAccessViewController.memExToAddress5,
        ]
        
        // MARK: MEMEXToWriteData
        memoryAccessViewController.lines[TouchPointNames.memExToWriteDataEnd] = [
            memoryAccessViewController.memExToWriteData1
        ]
        
        // MARK: MEMReadDataToWB
        memoryAccessViewController.lines[TouchPointNames.memReadDataToWbEnd] = [
            memoryAccessViewController.memReadDataToWb1
        ]
        
        // MARK: MEMRegDstEXToWB
        memoryAccessViewController.lines[TouchPointNames.memRegDstExToWbEnd] = [
            memoryAccessViewController.memRegDstExToWb1
        ]
        
        // MARK: MEMRegDstWBToEX
        memoryAccessViewController.lines[TouchPointNames.memRegDstWbToExEnd] = [
            memoryAccessViewController.memRegDstWbToEx1
        ]
        
        // MARK: MEMMEMToRegWBToEX
        memoryAccessViewController.lines[TouchPointNames.memMemToRegWbToExEnd] = [
            memoryAccessViewController.memMemToRegWbToEx1
        ]
        
        // Setup all touch points
        memoryAccessViewController.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(DotModel.defaultDotModel())
        }
        
        // Setup all lines
        for (_, v) in memoryAccessViewController.lines {
            v.forEach { line in
                line.setup()
            }
        }
    }
    
    func memoryAccessViewControllerDidSwipeLeft(
        _ memoryAccessViewController: MemoryAccessViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func memoryAccessViewControllerDidSwipeRight(
        _ memoryAccessViewController: MemoryAccessViewController) {
        self.showWriteBackViewController()
    }
    
    func memoryAccessViewController(
        _ memoryAccessViewController: MemoryAccessViewController) {
        
    }
    
}

// MARK: WriteBackViewControllerDelegate

extension ALUCoordinator: WriteBackViewControllerDelegate {
    func writeBackViewControllerOnTouchesBegan(_ writeBackViewController: WriteBackViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        drawingService.clearDrawing(
            imageView: writeBackViewController.drawingImageView)
        
        writeBackStateService.handleTouchesBegan(
            touches,
            with: event,
            touchPoints: writeBackViewController.touchPoints,
            view: writeBackViewController.drawingImageView)
    }
    
    func writeBackViewControllerOnTouchesMoved(_ writeBackViewController: WriteBackViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        // todo: pass in only drawingImageView
        writeBackStateService.handleTouchesMoved(
            touches,
            with: event,
            imageView: writeBackViewController.drawingImageView,
            view: writeBackViewController.drawingImageView,
            withDrawing: drawingService,
            touchPoints: writeBackViewController.touchPoints,
            lines: writeBackViewController.lines)
    }
    
    func writeBackViewControllerOnTouchesEnded(_ writeBackViewController: WriteBackViewController) {
        writeBackStateService.resetState()
    }
    
    func writeBackViewControllerOnTouchesCancelled(_ writeBackViewController: WriteBackViewController) {
        drawingService.resumeTouchInput()
        writeBackStateService.resetState()
    }
    
    func writeBackViewControllerClearDrawing(_ writeBackViewController: WriteBackViewController) {
        drawingService.clearDrawing(imageView: writeBackViewController.drawingImageView)
    }
    
    func writeBackViewControllerSetup(_ writeBackViewController: WriteBackViewController) {
        // Setup ProgressView
        writeBackViewController.progressView.progress = 0.0
        writeBackViewController.progressView.progressTintColor = UIColor.green
        
        // Setup event subscribers
        SwiftEventBus.onMainThread(writeBackViewController, name: Events.aluWriteBackOnCorrect) { result in
            let progress: Float = result?.object as! Float
            writeBackViewController.progressView.setProgress(progress, animated: true)
            
            // If progress is complete...
            if (progress == 1) {
                // ...animate tab bar after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    // Begin tab bar animation
                    writeBackViewController.wbMemTab.setStageFinished()
                }
            }
        }
        
        // Setup TouchPointViews
        writeBackViewController.wbMemReadDataToMuxStart.name = TouchPointNames.wbMemReadDataToMuxStart
        writeBackViewController.wbMemReadDataToMuxEnd.name = TouchPointNames.wbMemReadDataToMuxEnd
        writeBackViewController.wbMemAddressToMuxStart.name = TouchPointNames.wbMemAddressToMuxStart
        writeBackViewController.wbMemAddressToMuxEnd.name = TouchPointNames.wbMemAddressToMuxEnd
        writeBackViewController.wbMuxToIfWriteDataStart.name = TouchPointNames.wbMuxToIfWriteDataStart
        writeBackViewController.wbMuxToIfWriteDataEnd.name = TouchPointNames.wbMuxToIfWriteDataEnd
        writeBackViewController.wbMemToIfWriteAddressStart.name = TouchPointNames.wbMemToIfWriteAddressStart
        writeBackViewController.wbMemToIfWriteAddressEnd.name = TouchPointNames.wbMemToIfWriteAddressEnd
        
        writeBackViewController.touchPoints = [
            writeBackViewController.wbMemReadDataToMuxStart,
            writeBackViewController.wbMemReadDataToMuxEnd,
            writeBackViewController.wbMemAddressToMuxStart,
            writeBackViewController.wbMemAddressToMuxEnd,
            writeBackViewController.wbMuxToIfWriteDataStart,
            writeBackViewController.wbMuxToIfWriteDataEnd,
            writeBackViewController.wbMemToIfWriteAddressStart,
            writeBackViewController.wbMemToIfWriteAddressEnd,
        ]
        
        // Setup lines
        
        // WBMEMReadDataToMUX
        writeBackViewController.lines[TouchPointNames.wbMemReadDataToMuxEnd] = [
            writeBackViewController.wbMemReadDataToMux1
        ]
        
        // WBMEMAddressToMux
        writeBackViewController.lines[TouchPointNames.wbMemAddressToMuxEnd] = [
            writeBackViewController.wbMemAddressToMux1
        ]
        
        // WBMUXToIFWriteData
        writeBackViewController.lines[TouchPointNames.wbMuxToIfWriteDataEnd] = [
            writeBackViewController.wbMuxToIfWriteData1,
            writeBackViewController.wbMuxToIfWriteData2,
            writeBackViewController.wbMuxToIfWriteData3,
        ]
        
        // WBMEMToIFWriteAddress
        writeBackViewController.lines[TouchPointNames.wbMemToIfWriteAddressEnd] = [
            writeBackViewController.wbMemToIfWriteAddress1,
            writeBackViewController.wbMemToIfWriteAddress2,
            writeBackViewController.wbMemToIfWriteAddress3,
        ]
        
        // Setup all touch points
        writeBackViewController.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(DotModel.defaultDotModel())
        }
        
        // Setup all lines
        for (_, v) in writeBackViewController.lines {
            v.forEach { line in
                line.setup()
            }
        }
    }
    
    func writeBackViewControllerDidSwipeLeft(_ writeBackViewController: WriteBackViewController) {
        if (!writeBackStateService.isDrawing) {
            self.navigationController.popViewController(animated: true)
            
            // Reset animations
            guard let tvc = self.navigationController.topViewController else {
                return
            }
            if (tvc.nibName == "MemoryAccessView") {
                let mavc: MemoryAccessViewController = tvc as! MemoryAccessViewController
                mavc.touchPoints.forEach { tp in
                    if (!tp.isHidden) {
                        tp.setupWith(DotModel.defaultDotModel())
                    }
                }
            }
        }
    }
    
    func writeBackViewControllerDidSwipeRight(_ writeBackViewController: WriteBackViewController) {
    }
    
    func writeBackViewControllerDidTapDone(_ writeBackViewController: WriteBackViewController) {
    }
    
    func writeBackViewController(_ writeBackViewController: WriteBackViewController) {
        
    }
}