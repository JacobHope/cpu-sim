//
// Created by Jacob Morgan Hope on 2019-04-24.
// Copyright (c) 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation

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