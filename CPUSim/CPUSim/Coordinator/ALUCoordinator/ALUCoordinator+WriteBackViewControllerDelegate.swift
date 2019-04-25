//
// Created by Jacob Morgan Hope on 2019-04-24.
// Copyright (c) 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation

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
            resetPreviousViewControllerAnimations()
        }
    }
    
    func wbvcViewWillDisappear(_ wbvc: WriteBackViewController) {
        resetPreviousViewControllerAnimations()
    }
    
    func wbvcViewWillAppear(_ wbvc: WriteBackViewController) {
        // Reset animations
        wbvc.touchPoints.forEach { tp in
            if (!tp.isHidden) {
                tp.setupWith(DotModel.defaultDotModel())
            }
        }
    }

    func writeBackViewControllerDidSwipeRight(_ writeBackViewController: WriteBackViewController) {
    }

    func writeBackViewControllerDidTapDone(_ writeBackViewController: WriteBackViewController) {
    }

    func writeBackViewController(_ writeBackViewController: WriteBackViewController) {

    }
    
    private func resetPreviousViewControllerAnimations() {
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
