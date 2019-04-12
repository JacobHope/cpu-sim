//
//  BranchCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/31/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

protocol BranchCoordinatorDelegate: class {
    func branchCoordinatorDidRequestCancel(branchCoordinator: BranchCoordinator)
    func branchCoordinator(aluCoordinator: BranchCoordinator, payload: BranchCoordinatorPayload)
}

class BranchCoordinatorPayload {
    
}

class BranchCoordinator: RootViewCoordinator {
    
    // MARK: Properties
    
    let services: Services
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    weak var delegate: BranchCoordinatorDelegate?
    var orderPayload: BranchCoordinatorPayload?
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    // MARK: Init
    
    init(services: Services) {
        self.services = services
    }
    
    // MARK: Functions
    
    func start() {
        self.showFetchViewController()
    }
    
    func showFetchViewController() {
        let fetchViewController = FetchViewController(services: self.services)
        fetchViewController.delegate = self
        self.navigationController.viewControllers = [fetchViewController]
    }
    
    func showDecodeViewController() {
        let decodeViewController = DecodeViewController(services: self.services)
        decodeViewController.delegate = self
        self.navigationController.pushViewController(decodeViewController, animated: true)
    }
    
    func showExecuteViewController() {
        let executeViewController = ExecuteViewController(services: self.services)
        executeViewController.delegate = self
        self.navigationController.pushViewController(executeViewController, animated: true)
    }
    
    func showMemoryAccessViewController() {
        let memoryAccessViewController = MemoryAccessViewController(services: self.services)
        memoryAccessViewController.delegate = self
        self.navigationController.pushViewController(memoryAccessViewController, animated: true)
    }
    
    func showWriteBackViewController() {
        let writeBackViewController = WriteBackViewController(services: self.services)
        writeBackViewController.delegate = self
        self.navigationController.pushViewController(writeBackViewController, animated: true)
    }
}

// MARK: FetchViewControllerDelegate
extension BranchCoordinator: FetchViewControllerDelegate {
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController) {
        self.navigationController.popViewController(animated: true)
    }
    
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController) {
        self.showDecodeViewController()
    }
    
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController) {
        self.delegate?.branchCoordinatorDidRequestCancel(branchCoordinator: self)
    }
    
    func fetchViewController(_ fetchViewController: FetchViewController) {
    }
}

// MARK: DecodeControllerDelegate
extension BranchCoordinator: DecodeViewControllerDelegate {
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
extension BranchCoordinator: ExecuteViewControllerDelegate {
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
extension BranchCoordinator: MemoryAccessViewControllerDelegate {
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
extension BranchCoordinator: WriteBackViewControllerDelegate {
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
