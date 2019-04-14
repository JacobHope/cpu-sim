//
//  ALUCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/31/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

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
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    private let drawingService: Drawing
    private let fetchStateService: State
    private var fetchViewController: FetchViewController?
    
    // MARK: Init
    
    init(drawingService: Drawing,
         fetchStateService: State) {
        self.drawingService = drawingService
        self.fetchStateService = fetchStateService
    }
    
    // MARK: Functions
    
    func start() {
        self.showFetchViewController()
    }
    
    func showFetchViewController() {
        let fetchViewController = FetchViewController()
        fetchViewController.fetchViewControllerDelegate = self
        self.navigationController.viewControllers = [fetchViewController]
        self.fetchViewController = fetchViewController
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
         let writeBackViewController = WriteBackViewController()
         writeBackViewController.delegate = self
         self.navigationController.pushViewController(writeBackViewController, animated: true)
    }
}

// MARK: FetchViewControllerDelegate
extension ALUCoordinator: FetchViewControllerDelegate {
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController) {
        self.showDecodeViewController()
    }
    
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController) {
        self.delegate?.aluCoordinatorDidRequestCancel(aluCoordinator: self)
    }
    
    func fetchViewController(_ fetchViewController: FetchViewController) {
        //self.showDecodeViewController()
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.fetchViewController == nil) {
            return
        }
        
        fetchStateService.handleTouchesBegan(
            touches,
            with: event,
            touchPoints: self.fetchViewController!.touchPoints,
            view: self.fetchViewController!.view)
        
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.fetchViewController == nil) {
            return
        }
        
        fetchStateService.handleTouchesMoved(
            touches,
            with: event,
            imageView: self.fetchViewController!.drawingImageView,
            view: self.fetchViewController!.view,
            withDrawing: drawingService,
            touchPoints: self.fetchViewController!.touchPoints,
            lines: self.fetchViewController!.lines)
    }
    
    func onTouchesEnded() {
        fetchStateService.resetState()
    }
    
    func onTouchesCancelled() {
        drawingService.resumeTouchInput()
        fetchStateService.resetState()
    }
    
    func clearDrawing() {
        if (self.fetchViewController == nil) {
            return
        }
        drawingService.clearDrawing(imageView: self.fetchViewController!.drawingImageView)
    }
    
    func setup() {
        self.fetchViewController?.touchPoints.forEach { touchPoint in
            touchPoint.setupWith(
                DotModel(
                    x: -4.75,
                    y: -4.75,
                    radius: 10.0))
        }
        
        self.fetchViewController?.lines.forEach { line in
            line.setup()
        }
    }
}

// MARK: DecodeViewControllerDelegate
extension ALUCoordinator: DecodeViewControllerDelegate {
    func decodeViewControllerDidSwipeLeft(_ decodeViewController: DecodeViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func decodeViewControllerDidSwipeRight(_ decodeViewController: DecodeViewController) {
        self.showExecuteViewController()
    }
    
    func decodeViewController(_ decodeViewController: DecodeViewController) {
        
    }
    
}

// MARK: ExecuteViewControllerDelegate
extension ALUCoordinator: ExecuteViewControllerDelegate {
    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController) {
        self.showMemoryAccessViewController()
    }
    
    
    func executeViewController(_ executeViewController: ExecuteViewController) {
        
    }
    
}

// MARK: MemoryAccessViewControllerDelegate
extension ALUCoordinator: MemoryAccessViewControllerDelegate {
    func memoryAccessViewControllerDidSwipeLeft(_ memoryAccessViewController: MemoryAccessViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func memoryAccessViewControllerDidSwipeRight(_ memoryAccessViewController: MemoryAccessViewController) {
        self.showWriteBackViewController()
    }
    
   
    func memoryAccessViewController(_ memoryAccessViewController: MemoryAccessViewController) {
        
    }
    
}

// MARK: WriteBackViewControllerDelegate
extension ALUCoordinator: WriteBackViewControllerDelegate {
    func writeBackViewControllerDidSwipeLeft(_ writeBackViewController: WriteBackViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func writeBackViewControllerDidSwipeRight(_ writeBackViewController: WriteBackViewController) {
    }
    
    func writeBackViewControllerDidTapDone(_ writeBackViewController: WriteBackViewController) {
    }
    
    func writeBackViewController(_ writeBackViewController: WriteBackViewController) {
        
    }
}
