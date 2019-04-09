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
                touchPoints: self.viewController!.touchPoints,
                view: self.viewController!.view)

    }

    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.viewController == nil) {
            return
        }

        stateService.handleTouchesMoved(
                touches,
                with: event,
                imageView: self.viewController!.imageView,
                view: self.viewController!.view,
                withDrawing: drawingService,
                touchPoints: self.viewController!.touchPoints,
                lines: self.viewController!.lines)
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
        drawingService.clearDrawing(imageView: self.viewController!.imageView)
    }

    func setup() {
        self.viewController?.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(
                    DotModel(
                            x: -4.75,
                            y: -4.75,
                            radius: 10.0))
        }

        self.viewController?.lines.forEach { line in
            line.setup()
        }
    }
}
