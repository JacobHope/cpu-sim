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
    func evcViewWillDisappear(_ evc: ExecuteViewController) {
        resetPreviousViewControllerAnimations()
    }
    
    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController) {
        self.navigationController.popViewController(animated: true)
        resetPreviousViewControllerAnimations()
    }

    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController) {
        self.showMemoryAccessViewController()
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
