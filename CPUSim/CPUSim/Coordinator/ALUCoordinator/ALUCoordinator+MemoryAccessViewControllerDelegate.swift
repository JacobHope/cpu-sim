//
// Created by Jacob Morgan Hope on 2019-04-24.
// Copyright (c) 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation

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

    public func mavcViewWillDisappear(_ mavc: MemoryAccessViewController) {
        resetPreviousViewControllerAnimations()
    }

    public func mavcViewWillAppear(_ mavc: MemoryAccessViewController) {
        // Reset animations
        mavc.touchPoints.forEach { tp in
            if (!tp.isHidden) {
                tp.setupWith(DotModel.defaultDotModel())
            }
        }
    }

    func memoryAccessViewControllerDidSwipeLeft(
            _ memoryAccessViewController: MemoryAccessViewController) {
        if (!memoryAccessStateService.isDrawing) {
            self.navigationController.popViewController(animated: true)
            resetPreviousViewControllerAnimations()
        }
    }

    func memoryAccessViewControllerDidSwipeRight(
            _ memoryAccessViewController: MemoryAccessViewController) {
        if (!memoryAccessStateService.isDrawing) {
            self.showWriteBackViewController()
        }
    }

    func memoryAccessViewController(
            _ memoryAccessViewController: MemoryAccessViewController) {

    }

    private func resetPreviousViewControllerAnimations() {
        // Reset animations
//        guard let tvc = self.navigationController.topViewController else {
//            return
//        }
//        if (tvc.nibName == "ExecuteView") {
//            let evc: ExecuteViewController = tvc as! ExecuteViewController
//            evc.touchPoints.forEach { tp in
//                if (!tp.isHidden) {
//                    tp.setupWith(DotModel.defaultDotModel())
//                }
//            }
//        }
    }

}
