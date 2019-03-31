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
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let viewController = ViewController(nibName: "ViewController", bundle: nil)
        presenter.pushViewController(viewController, animated: true)
        
        self.viewController = viewController
    }
}
