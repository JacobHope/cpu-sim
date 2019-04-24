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
        SwiftEventBus.onMainThread(decodeViewController, name: Events.aluFetchOnCorrect) { result in
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
        decodeViewController.completeButton.isHidden = true

        // Setup TouchPointViews
//        decodeViewController.ifMuxToPcStart.name = TouchPointNames.ifMuxToPcStart
//        decodeViewController.ifMuxToPcEnd.name = TouchPointNames.ifMuxToPcEnd
//        decodeViewController.ifPcToAluStart.name = TouchPointNames.ifPcToAluStart
//        decodeViewController.ifPcToAluEnd.name = TouchPointNames.ifPcToAluEnd
//        decodeViewController.ifPcToImEnd.name = TouchPointNames.ifPcToImEnd
//        decodeViewController.ifFourToAluStart.name = TouchPointNames.ifFourToAluStart
//        decodeViewController.ifFourToAluEnd.name = TouchPointNames.ifFourToAluEnd
//        decodeViewController.ifAluToMuxStart.name = TouchPointNames.ifAluToMuxStart
//        decodeViewController.ifAluToMuxEnd.name = TouchPointNames.ifAluToMuxEnd
//        decodeViewController.ifImToIdStart.name = TouchPointNames.ifImToIdStart
//        decodeViewController.ifImToIdEnd.name = TouchPointNames.ifImToIdEnd
//        decodeViewController.ifAluToIdEnd.name = TouchPointNames.ifAluToIdEnd

        decodeViewController.touchPoints = [
//            decodeViewController.ifMuxToPcStart,
//            decodeViewController.ifMuxToPcEnd,
//            decodeViewController.ifPcToAluStart,
//            decodeViewController.ifPcToAluEnd,
//            decodeViewController.ifPcToImEnd,
//            decodeViewController.ifFourToAluStart,
//            decodeViewController.ifFourToAluEnd,
//            decodeViewController.ifAluToMuxStart,
//            decodeViewController.ifAluToMuxEnd,
//            decodeViewController.ifImToIdStart,
//            decodeViewController.ifImToIdEnd,
//            decodeViewController.ifAluToIdEnd
        ]

        // Setup lines

        // IFMUXtoPC
        decodeViewController.lines[TouchPointNames.ifMuxToPcEnd] = [
//            decodeViewController.ifMuxToPc1,
//            decodeViewController.ifMuxToPc2,
//            decodeViewController.ifMuxToPc3
        ]

        // IFPCtoALU
        decodeViewController.lines[TouchPointNames.ifPcToAluEnd] = [
//            decodeViewController.ifPcToAlu1,
//            decodeViewController.ifPcToAlu2
        ]

        // IFPCtoIM
        decodeViewController.lines[TouchPointNames.ifPcToImEnd] = [
//            decodeViewController.ifPcToIm1
        ]

        // IFFourToALU
        decodeViewController.lines[TouchPointNames.ifFourToAluEnd] = [
//            decodeViewController.ifFourToAlu1
        ]

        // IFALUToMUX
        decodeViewController.lines[TouchPointNames.ifAluToMuxEnd] = [
//            decodeViewController.ifAluToMux1,
//            decodeViewController.ifAluToMux2,
//            decodeViewController.ifAluToMux3
        ]

        // IFIMtoID
        decodeViewController.lines[TouchPointNames.ifImToIdEnd] = [
//            decodeViewController.ifImToId1
        ]

        // IFALUToID
        decodeViewController.lines[TouchPointNames.ifAluToIdEnd] = [
//            decodeViewController.ifAluToId1
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
        }
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
        //self.showDecodeViewController()
    }
}
