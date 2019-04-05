//
//  ViewControllerCoordinator.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

class ViewControllerCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var viewController: ViewController?
    private let drawingService: Drawing
    private let stateService: State

    init(presenter: UINavigationController,
         drawingService: Drawing,
         stateService: State) {
        self.presenter = presenter
        self.drawingService = drawingService
        self.stateService = stateService
    }

    func start() {
        let viewController = ViewController(nibName: "ViewController", bundle: nil)
        viewController.delegate = self
        presenter.pushViewController(viewController, animated: true)

        self.viewController = viewController
    }
}

extension ViewControllerCoordinator: ViewControllerDelegate {
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.viewController == nil) {
            return
        }

        stateService.handleTouchesBegan(
                touches,
                with: event,
                inViewController: self.viewController!)
    }

    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.viewController == nil) {
            return
        }

        stateService.handleTouchesMoved(
                touches,
                with: event,
                inViewController: self.viewController!,
                withDrawing: drawingService)
    }

    func onTouchesEnded() {
        stateService.resetState()
    }

    func onTouchesCancelled() {
        drawingService.resumeTouchInput()
        stateService.resetState()
    }

    func clearDrawing() {
        if (self.viewController == nil) {
            return
        }
        drawingService.clearDrawing(inViewController: self.viewController!)
    }
}
