//
//  ApplicationCoordinator.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    let viewControllerCoordinator: ViewControllerCoordinator

    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.isHidden = true

        viewControllerCoordinator = ViewControllerCoordinator(
                presenter: rootViewController,
                drawingService: DrawingService(),
                stateService: StateService()
        )
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        viewControllerCoordinator.start()
    }
}
