//
//  ALUCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/31/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import EasyAnimation

protocol ALUCoordinatorDelegate: class {
    func aluCoordinatorDidRequestCancel(aluCoordinator: ALUCoordinator)
    func aluCoordinator(aluCoordinator: ALUCoordinator, payload: ALUCoordinatorPayload)
}

class ALUCoordinatorPayload {
    // Data passed through the view controllers
}

class ALUCoordinator: RootViewCoordinator {
    
    // MARK: Properties

    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    weak var delegate: ALUCoordinatorDelegate?
    var orderPayload: ALUCoordinatorPayload?
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    // MARK: Properties - Drawing State Services

    let drawingService: Drawing

    // MARK: Properties - Instruction State Services

    let fetchStateService: State
    let decodeStateService: State
    let memoryAccessStateService: State
    let writeBackStateService: State
    
    // MARK: Properties - VCs
    
    private var wbvc: WriteBackViewController? = nil
    
    // MARK: Init
    
    init(drawingService: Drawing,
         fetchStateService: State,
         decodeStateService: State,
         memoryAccessStateService: State,
         writeBackStateService: State) {
        self.drawingService = drawingService
        self.decodeStateService = decodeStateService
        self.fetchStateService = fetchStateService
        self.memoryAccessStateService = memoryAccessStateService
        self.writeBackStateService = writeBackStateService
    }
    
    // MARK: Functions
    
    func start() {
        self.showFetchViewController()
    }
    
    func showFetchViewController() {
        let fetchViewController = FetchViewController()
        fetchViewController.delegate = self
        self.navigationController.viewControllers = [fetchViewController]
    }
    
    func showDecodeViewController() {
         let decodeViewController = DecodeViewController()
         decodeViewController.delegate = self
         self.navigationController.pushViewController(decodeViewController, animated: true)
    }
     
    func showExecuteViewController() {
         let executeViewController = ExecuteViewController()
         executeViewController.delegate = self
         self.navigationController.pushViewController(executeViewController, animated: true)
    }
     
    func showMemoryAccessViewController() {
         let memoryAccessViewController = MemoryAccessViewController()
         memoryAccessViewController.delegate = self
         self.navigationController.pushViewController(memoryAccessViewController, animated: true)
    }
     
    func showWriteBackViewController() {
        // Lazy init the WriteBackViewController
        if (wbvc == nil) {
            wbvc = WriteBackViewController()
            wbvc?.delegate = self
        }
        
        // Safe bang due to lazy initialization above
        self.navigationController.pushViewController(wbvc!, animated: true)
    }
}
