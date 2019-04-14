//
//  StoreCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/31/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

protocol StoreCoordinatorDelegate: class {
    func storeCoordinatorDidRequestCancel(storeCoordinator: StoreCoordinator)
    func storeCoordinator(storeCoordinator: StoreCoordinator, payload: StoreCoordinatorPayload)
}

class StoreCoordinatorPayload {}

class StoreCoordinator: RootViewCoordinator {
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    weak var delegate: StoreCoordinatorDelegate?
    var orderPayload: StoreCoordinatorPayload?
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    // MARK: Init
    
    init() {
    }
    
    // MARK: Functions
    
    func start() {
        self.showFetchViewController()
    }
    
    func showFetchViewController() {
        let fetchViewController = FetchViewController()
        fetchViewController.fetchViewControllerDelegate = self
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
        let writeBackViewController = WriteBackViewController()
        writeBackViewController.delegate = self
        self.navigationController.pushViewController(writeBackViewController, animated: true)
    }
}

//// MARK: FetchViewControllerDelegate
extension StoreCoordinator: FetchViewControllerDelegate {
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController) {
        self.showDecodeViewController()
    }
    
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController) {
        self.delegate?.storeCoordinatorDidRequestCancel(storeCoordinator: self)
    }
    
    func fetchViewController(_ fetchViewController: FetchViewController) {
        //self.showDecodeViewController()
    }
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func onTouchesEnded() {
        
    }
    
    func onTouchesCancelled() {
        
    }
    
    func clearDrawing() {
        
    }
    
    func setup() {
        
    }
}

// MARK: DecodeControllerDelegate
extension StoreCoordinator: DecodeViewControllerDelegate {
    func decodeViewControllerDidSwipeLeft(_ decodeViewController: DecodeViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func decodeViewControllerDidSwipeRight(_ decodeViewController: DecodeViewController) {
        self.showExecuteViewController()
    }
    
    
    
    func decodeViewController(_ decodeViewController: DecodeViewController) {
        
    }
    
}

// MARK: ExecuteControllerDelegate
extension StoreCoordinator: ExecuteViewControllerDelegate {
    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController) {
        self.showMemoryAccessViewController()
    }
    
    
    func executeViewController(_ executeViewController: ExecuteViewController) {
        
    }
    
}

// MARK: MemoryAccessControllerDelegate
extension StoreCoordinator: MemoryAccessViewControllerDelegate {
    func memoryAccessViewControllerDidSwipeLeft(_ memoryAccessViewController: MemoryAccessViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func memoryAccessViewControllerDidSwipeRight(_ memoryAccessViewController: MemoryAccessViewController) {
        self.showWriteBackViewController()
    }
    
    
    func memoryAccessViewController(_ memoryAccessViewController: MemoryAccessViewController) {
        
    }
    
}

// MARK: WriteBackControllerDelegate
extension StoreCoordinator: WriteBackViewControllerDelegate {
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
