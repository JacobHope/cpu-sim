////
////  InstructionCoordinator.swift
////  CPUSim
////
////  Created by Jacob Morgan Hope on 4/4/19.
////  Copyright © 2019 Jacob M. Hope. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol InstructionCoordinatorDelegate: class {
//    
//    /// The user tapped the cancel button
//    func instructionCoordinatorDidRequestCancel(instructionCoordinatorDelegate: InstructionCoordinator)
//    
//    /// The user completed the instruction flow
//    func instructionCoordinator(instructionCoordinator: InstructionCoordinator, payload: InstructionCoordinatorPayload)
//}
//
//class InstructionCoordinatorPayload {
//    // Data passed through the view controllers
//}
//
//class InstructionCoordinator: RootViewCoordinator {
//    
//    // MARK: Properties
//    
//    let services: Services
//    var childCoordinators: [Coordinator] = []
//    var rootViewController: UIViewController {
//        return self.navigationController
//    }
//    weak var delegate: InstructionCoordinatorDelegate?
//    var instructionPayload: InstructionCoordinatorPayload?
//    private lazy var navigationController: UINavigationController = {
//        let navigationController = UINavigationController()
//        return navigationController
//    }()
//    
//    // MARK: Init
//    
//    init(services: Services) {
//        self.services = services
//    }
//    
//    // MARK: Functions
//    
//    func start() {
//        let fetchViewController = FetchViewController()
//        fetchViewController.delegate = self
//        self.navigationController.viewControllers = [fetchViewController]
//    }
//    
//    func showDecodeViewController() {
//         let decodeViewController = DecodeViewController()
//         decodeViewController.delegate = self
//         self.navigationController.pushViewController(decodeViewController, animated: true)
//    }
//     
//    func showExecuteViewController() {
//         let executeViewController = ExecuteViewController()
//         executeViewController.delegate = self
//         self.navigationController.pushViewController(executeViewController, animated: true)
//    }
//     
//    func showMemoryAccessViewController() {
//         let memoryAccessViewController = MemoryAccessViewController()
//         memoryAccessViewController.delegate = self
//         self.navigationController.pushViewController(memoryAccessViewController, animated: true)
//    }
//     
//    func showWriteBackViewController() {
//         let writeBackViewController = WriteBackViewController()
//         writeBackViewController.delegate = self
//         self.navigationController.pushViewController(writeBackViewController, animated: true)
//    }
//}
//
//// MARK: - FetchControllerDelegate
////extension InstructionCoordinator: FetchViewControllerDelegate {
////
////    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController) {
////        self.delegate?.instructionCoordinatorDidRequestCancel(instructionCoordinator: self)
////    }
////
////    func fetchViewController(_ fetchViewController: FetchViewController) {
////
////        self.instructionPayload = InstructionCoordinatorPayload()
////
////        self.showDecodeViewController()
////    }
////
////}
//
//
//// MARK: - DecodeControllerDelegate
//
//// MARK: - ExecuteControllerDelegate
//
//// MARK: - MemoryAccessControllerDelegate
//
//// MARK: - WriteBackControllerDelegate
