//
// Created by Jacob Morgan Hope on 2019-04-24.
// Copyright (c) 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation

// MARK: DecodeViewControllerDelegate

extension ALUCoordinator: DecodeViewControllerDelegate {
    func decodeViewControllerOnTouchesBegan(_ decodeViewController: DecodeViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        drawingService.clearDrawing(
                imageView: decodeViewController.drawingImageView)

        decodeStateService.handleTouchesBegan(
                touches,
                with: event,
                touchPoints: decodeViewController.touchPoints,
                view: decodeViewController.drawingImageView)
    }

    func decodeViewControllerOnTouchesMoved(_ decodeViewController: DecodeViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        // todo: pass in only drawingImageView
        decodeStateService.handleTouchesMoved(
                touches,
                with: event,
                imageView: decodeViewController.drawingImageView,
                view: decodeViewController.drawingImageView,
                withDrawing: drawingService,
                touchPoints: decodeViewController.touchPoints,
                lines: decodeViewController.lines)
    }

    func decodeViewControllerOnTouchesEnded(_ decodeViewController: DecodeViewController) {
        decodeStateService.resetState()
    }

    func decodeViewControllerOnTouchesCancelled(_ decodeViewController: DecodeViewController) {
        drawingService.resumeTouchInput()
        decodeStateService.resetState()
    }

    func decodeViewControllerClearDrawing(_ decodeViewController: DecodeViewController) {
        drawingService.clearDrawing(imageView: decodeViewController.drawingImageView)
    }

    func decodeViewControllerSetup(_ decodeViewController: DecodeViewController) {
        // Setup ProgressView
        decodeViewController.progressView.progress = 0.0
        decodeViewController.progressView.progressTintColor = UIColor.green

        // Setup event subscribers
        SwiftEventBus.onMainThread(decodeViewController, name: Events.aluDecodeOnCorrect) { result in
            let progress: Float = result?.object as! Float
            decodeViewController.progressView.setProgress(progress, animated: true)

            // If progress is complete...
            if (progress == 1) {
                // ...show complete button and animate tab bar after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    // Unhide complete button
//                    decodeViewController.completeButton.isHidden = false
//
//                    // Begin complete button animation
//                    UIView.beginCompleteButtonAnimation(decodeViewController.completeButton)
//
//                    // Begin tab bar animation
//                    decodeViewController.ifIdTab.setStageFinished()
                }
            }
        }

        // Setup complete button
        //decodeViewController.completeButton.isHidden = true

        // Setup TouchPointViews
        decodeViewController.idExToWriteDataStart.name = TouchPointNames.idExToWriteDataStart
        decodeViewController.idExToWriteDataEnd.name = TouchPointNames.idExToWriteDataEnd
        decodeViewController.idIfToExStart.name = TouchPointNames.idIfToExStart
        decodeViewController.idIfToExEnd.name = TouchPointNames.idIfToExEnd
        decodeViewController.idIfStart.name = TouchPointNames.idIfStart
        decodeViewController.idIfToReadAddress1End.name = TouchPointNames.idIfToReadAddress1End
        decodeViewController.idIfToReadAddress2End.name = TouchPointNames.idIfToReadAddress2End
        decodeViewController.idIfToMux0End.name = TouchPointNames.idIfToMux0End
        decodeViewController.idIfToMux1End.name = TouchPointNames.idIfToMux1End
        decodeViewController.idIfToSignExtendEnd.name = TouchPointNames.idIfToSignExtendEnd
        decodeViewController.idMuxToWriteAddressStart.name = TouchPointNames.idMuxToWriteAddressStart
        decodeViewController.idMuxToWriteAddressEnd.name = TouchPointNames.idMuxToWriteAddressEnd
        decodeViewController.idReadData1ToExStart.name = TouchPointNames.idReadData1ToExStart
        decodeViewController.idReadData1ToExEnd.name = TouchPointNames.idReadData1ToExEnd
        decodeViewController.idReadData2ToExStart.name = TouchPointNames.idReadData2ToExStart
        decodeViewController.idReadData2ToExEnd.name = TouchPointNames.idReadData2ToExEnd
        decodeViewController.idSignExtendToExStart.name = TouchPointNames.idSignExtendToExStart
        decodeViewController.idSignExtendToExEnd.name = TouchPointNames.idSignExtendToExEnd

        //Setup all touch points
        decodeViewController.touchPoints = [
            decodeViewController.idExToWriteDataStart,
            decodeViewController.idExToWriteDataEnd,
            decodeViewController.idIfToExStart,
            decodeViewController.idIfToExEnd,
            decodeViewController.idIfStart,
            decodeViewController.idIfToReadAddress1End,
            decodeViewController.idIfToReadAddress2End,
            decodeViewController.idIfToMux0End,
            decodeViewController.idIfToMux1End,
            decodeViewController.idIfToSignExtendEnd,
            decodeViewController.idMuxToWriteAddressStart,
            decodeViewController.idMuxToWriteAddressEnd,
            decodeViewController.idReadData1ToExStart,
            decodeViewController.idReadData1ToExEnd,
            decodeViewController.idReadData2ToExStart,
            decodeViewController.idReadData2ToExEnd,
            decodeViewController.idSignExtendToExStart,
            decodeViewController.idSignExtendToExEnd
        ]

        // Setup lines
        decodeViewController.lines[TouchPointNames.idExToWriteDataEnd] = [
            decodeViewController.idExToWriteData1,
            decodeViewController.idExToWriteData2,
            decodeViewController.idExToWriteData3
        ]

        decodeViewController.lines[TouchPointNames.idIfToExEnd] = [
            decodeViewController.idIfToEx1
        ]

        decodeViewController.lines[TouchPointNames.idIfToReadAddress1End] = [
            decodeViewController.idIf1,
            decodeViewController.idIf2,
            decodeViewController.idIfToReadAddress1_1,
            decodeViewController.idIfToReadAddress1_2
        ]

        decodeViewController.lines[TouchPointNames.idIfToReadAddress2End] = [
            decodeViewController.idIf1,
            decodeViewController.idIf2,
            decodeViewController.idIfToReadAddress2_1,
            decodeViewController.idIfToReadAddress2_2
        ]

        decodeViewController.lines[TouchPointNames.idIfToMux0End] = [
            decodeViewController.idIf1,
            decodeViewController.idIf2,
            decodeViewController.idIfToMux0_1,
            decodeViewController.idIfToMux0_2,
            decodeViewController.idIfToMux0_3
        ]

        decodeViewController.lines[TouchPointNames.idIfToMux1End] = [
            decodeViewController.idIf1,
            decodeViewController.idIf2,
            decodeViewController.idIfToMux1_1,
            decodeViewController.idIfToMux1_2
        ]

        decodeViewController.lines[TouchPointNames.idIfToSignExtendEnd] = [
            decodeViewController.idIf1,
            decodeViewController.idIf2,
            decodeViewController.idIfToSignExtend1,
            decodeViewController.idIfToSignExtend2
        ]

        decodeViewController.lines[TouchPointNames.idMuxToWriteAddressEnd] = [
            decodeViewController.idMuxToWriteAddress1,
            decodeViewController.idMuxToWriteAddress2,
        ]

        decodeViewController.lines[TouchPointNames.idReadData1ToExEnd] = [
            decodeViewController.idReadData1ToEx1
        ]

        decodeViewController.lines[TouchPointNames.idReadData2ToExEnd] = [
            decodeViewController.idReadData2ToEx1
        ]

        decodeViewController.lines[TouchPointNames.idSignExtendToExEnd] = [
            decodeViewController.idSignExtendToEx1
        ]


        // Setup all touch points
        decodeViewController.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(DotModel.defaultDotModel())
        }

        // Setup all lines
        for (_, v) in decodeViewController.lines {
            v.forEach { line in
                line.setup()
            }
        }
    }

    func decodeViewControllerDidSwipeLeft(_ decodeViewController: DecodeViewController) {
        if (!decodeStateService.isDrawing) {
            self.navigationController.popViewController(animated: true)
            resetPreviousViewControllerAnimations()
        }
    }
    
    func decodeViewControllerViewWillDisappear(_ dvc: DecodeViewController) {
        resetPreviousViewControllerAnimations()
    }

    func decodeViewControllerDidSwipeRight(_ decodeViewController: DecodeViewController) {
        if (!decodeStateService.isDrawing) {
            // Hide complete button
           // decodeViewController.completeButton.isHidden = true
            self.showExecuteViewController()
        }
    }

    func decodeViewControllerDidTapClose(_ decodeViewController: DecodeViewController) {
        self.delegate?.aluCoordinatorDidRequestCancel(aluCoordinator: self)
    }

    func decodeViewController(_ decodeViewController: DecodeViewController) {
        self.showDecodeViewController()
    }
    
    private func resetPreviousViewControllerAnimations() {
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
}
