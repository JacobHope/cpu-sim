//
// Created by Jacob Morgan Hope on 2019-04-24.
// Copyright (c) 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation


// MARK: ExecuteViewControllerDelegate

extension ALUCoordinator: ExecuteViewControllerDelegate {
    func executeViewControllerOnTouchesBegan(_ executeViewController: ExecuteViewController, _ touches: Set<UITouch>, with event: UIEvent?) {

        drawingService.clearDrawing(
                imageView: executeViewController.drawingImageView)

        executeStateService.handleTouchesBegan(
                touches,
                with: event,
                touchPoints: executeViewController.touchPoints,
                view: executeViewController.drawingImageView)
    }

    func executeViewControllerOnTouchesMoved(_ executeViewController: ExecuteViewController, _ touches: Set<UITouch>, with event: UIEvent?) {

        // todo: pass in only drawingImageView
        executeStateService.handleTouchesMoved(
                touches,
                with: event,
                imageView: executeViewController.drawingImageView,
                view: executeViewController.drawingImageView,
                withDrawing: drawingService,
                touchPoints: executeViewController.touchPoints,
                lines: executeViewController.lines)
    }

    func executeViewControllerOnTouchesEnded(_ executeViewController: ExecuteViewController) {
        executeStateService.resetState()
    }

    func executeViewControllerOnTouchesCancelled(_ executeViewController: ExecuteViewController) {
        drawingService.resumeTouchInput()
        executeStateService.resetState()
    }

    func executeViewControllerClearDrawing(_ executeViewController: ExecuteViewController) {
        drawingService.clearDrawing(imageView: executeViewController.drawingImageView)
    }

    func executeViewControllerSetup(_ executeViewController: ExecuteViewController) {
        // Setup ProgressView
        executeViewController.progressView.progress = 0.0
        executeViewController.progressView.progressTintColor = UIColor.green

        // Setup event subscribers
        SwiftEventBus.onMainThread(executeViewController, name: Events.aluExecuteOnCorrect) { result in
            let progress: Float = result?.object as! Float
            executeViewController.progressView.setProgress(progress, animated: true)

            // If progress is complete...
            if (progress == 1) {
                // ...animate tab bar after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    // Begin tab bar animation
                    executeViewController.exIdTab.setStageFinished()
                    executeViewController.exMemTab.setStageFinished()
                }
            }
        }

        // Setup TouchPointViews
        executeViewController.exIdAddToAddStart.name = TouchPointNames.exIdAddToAddStart
        executeViewController.exIdAddToAddEnd.name = TouchPointNames.exIdAddToAddEnd
        executeViewController.exShiftLeftToAddStart.name = TouchPointNames.exShiftLeftToAddStart
        executeViewController.exShiftLeftToAddEnd.name = TouchPointNames.exShiftLeftToAddEnd
        executeViewController.exAluToMemStart.name = TouchPointNames.exAluToMemStart
        executeViewController.exAluToMemEnd.name = TouchPointNames.exAluToMemEnd
        executeViewController.exIdSignExtendToShiftLeftStart.name = TouchPointNames.exIdSignExtendToShiftLeftStart
        executeViewController.exIdSignExtendToShiftLeftEnd.name = TouchPointNames.exIdSignExtendToShiftLeftEnd
        executeViewController.exIdSignExtendToMuxEnd.name = TouchPointNames.exIdSignExtendToMuxEnd
        executeViewController.exIdReadDataOneToAluStart.name = TouchPointNames.exIdReadDataOneToAluStart
        executeViewController.exIdReadDataOneToAluEnd.name = TouchPointNames.exIdReadDataOneToAluEnd
        executeViewController.exIdReadDataTwoToMuxStart.name = TouchPointNames.exIdReadDataTwoToMuxStart
        executeViewController.exIdReadDataTwoToMuxEnd.name = TouchPointNames.exIdReadDataTwoToMuxEnd
        executeViewController.exMuxToAluStart.name = TouchPointNames.exMuxToAluStart
        executeViewController.exMuxToAluEnd.name = TouchPointNames.exMuxToAluEnd

        executeViewController.touchPoints = [
            executeViewController.exIdAddToAddStart,
            executeViewController.exIdAddToAddEnd,
            executeViewController.exShiftLeftToAddStart,
            executeViewController.exShiftLeftToAddEnd,
            executeViewController.exAluToMemStart,
            executeViewController.exAluToMemEnd,
            executeViewController.exIdSignExtendToShiftLeftStart,
            executeViewController.exIdSignExtendToShiftLeftEnd,
            executeViewController.exIdSignExtendToMuxEnd,
            executeViewController.exIdReadDataOneToAluStart,
            executeViewController.exIdReadDataOneToAluEnd,
            executeViewController.exIdReadDataTwoToMuxStart,
            executeViewController.exIdReadDataTwoToMuxEnd,
            executeViewController.exMuxToAluStart,
            executeViewController.exMuxToAluEnd
        ]

        // Setup lines

        // MARK: exIdAddToAdd
        executeViewController.lines[TouchPointNames.exIdAddToAddEnd] = [
            executeViewController.exIdAddToAdd1
        ]

        // MARK: exShiftLeftToAdd
        executeViewController.lines[TouchPointNames.exShiftLeftToAddEnd] = [
            executeViewController.exShiftLeftToAdd1
        ]

        // MARK: exAluToMem
        executeViewController.lines[TouchPointNames.exAluToMemEnd] = [
            executeViewController.exAluToMem1
        ]

        // MARK: exIdSignExtendToShiftLeft
        executeViewController.lines[TouchPointNames.exIdSignExtendToShiftLeftEnd] = [
            executeViewController.exIdSignExtendToShiftLeft1,
            executeViewController.exIdSignExtendToShiftLeft2,
            executeViewController.exIdSignExtendToShiftLeft3,
        ]

        // MARK: exIdSignExtendToMux
        executeViewController.lines[TouchPointNames.exIdSignExtendToMuxEnd] = [
            executeViewController.exIdSignExtendToMux1,
            executeViewController.exIdSignExtendToMux2,
            executeViewController.exIdSignExtendToMux3,
        ]

        // MARK: exIdReadDataOneToAlu
        executeViewController.lines[TouchPointNames.exIdReadDataOneToAluEnd] = [
            executeViewController.exIdreadDataOneToAlu1
        ]

        // MARK: exIdReadDataTwoToMux
        executeViewController.lines[TouchPointNames.exIdReadDataTwoToMuxEnd] = [
            executeViewController.exIdReadDataTwoToMux1,
            executeViewController.exIdReadDataTwoToMux2,
            executeViewController.exIdReadDataTwoToMux3,
            executeViewController.exIdReadDataTwoToMux4,
            executeViewController.exIdReadDataTwoToMux5,
        ]

        // MARK: exMuxToAlu
        executeViewController.lines[TouchPointNames.exMuxToAluEnd] = [
            executeViewController.exMuxToAlu1
        ]

        // Setup all touch points
        executeViewController.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(DotModel.defaultDotModel())
        }

        // Setup all lines
        for (_, v) in executeViewController.lines {
            v.forEach { line in
                line.setup()
            }
        }
    }

    func evcViewWillAppear(_ mavc: ExecuteViewController) {
        // Reset animations
        mavc.touchPoints.forEach { tp in
            if (!tp.isHidden) {
                tp.setupWith(DotModel.defaultDotModel())
            }
        }
    }

    func evcViewWillDisappear(_ evc: ExecuteViewController) {
        resetPreviousViewControllerAnimations()
    }

    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController) {
        if (!executeStateService.isDrawing) {
            self.navigationController.popViewController(animated: true)
            resetPreviousViewControllerAnimations()
        }
    }

    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController) {
        if (!executeStateService.isDrawing) {
            self.showMemoryAccessViewController()
        }
    }


    func executeViewController(_ executeViewController: ExecuteViewController) {

    }

    private func resetPreviousViewControllerAnimations() {
        // Reset animations
        guard let tvc = self.navigationController.topViewController else {
            return
        }
        if (tvc.nibName == "DecodeView") {
            let dvc: DecodeViewController = tvc as! DecodeViewController
            dvc.touchPoints.forEach { tp in
                if (!tp.isHidden) {
                    tp.setupWith(DotModel.defaultDotModel())
                }
            }
        }
    }
}
