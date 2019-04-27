//
//  AppCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/28/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

/// The AppCoordinator is our first coordinator
/// In this example the AppCoordinator as a rootViewController
class AppCoordinator: RootViewCoordinator {
    
    // MARK: - Properties
    
    let services: Services
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    /// Window to manage
    let window: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    // MARK: - Init
    
    public init(window: UIWindow, services: Services) {
        self.services = services
        self.window = window
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Functions
    
    /// Starts the coordinator
    public func start() {
        self.showMenuViewController()
    }
    
    /// Creates a new MenuViewController and places it into the navigation controller
    private func showMenuViewController() {
        let menuViewController = MenuViewController()
        menuViewController.delegate = self
        self.navigationController.viewControllers = [menuViewController]
    }
}

// MARK: - MenuViewControllerDelegate
extension AppCoordinator: MenuViewControllerDelegate {
    func menuViewControllerDidTapALUButton(menuViewController: MenuViewController) {
        let aluCoordinator = ALUCoordinator(drawingService: DrawingService(),
            fetchStateService: ALUFetchStateService(),
            decodeStateService: ALUDecodeStateService(),
            executeStateService: ALUExecuteStateService(),
            memoryAccessStateService: ALUMemoryAccessStateService(),
            writeBackStateService: ALUWriteBackStateService())
        aluCoordinator.delegate = self
        aluCoordinator.start()
        self.addChildCoordinator(aluCoordinator)
        self.rootViewController.present(aluCoordinator.rootViewController,
                                        animated: true, completion: nil)
    }
    
    func menuViewControllerDidTapLoadButton(menuViewController: MenuViewController) {
//        let loadCoordinator = LoadCoordinator()
//        loadCoordinator.delegate = self
//        loadCoordinator.start()
//        self.addChildCoordinator(loadCoordinator)
//        self.rootViewController.present(loadCoordinator.rootViewController,
//                                        animated: true, completion: nil)
    }
    
    func menuViewControllerDidTapStoreButton(menuViewController: MenuViewController) {
//        let storeCoordinator = StoreCoordinator()
//        storeCoordinator.delegate = self
//        storeCoordinator.start()
//        self.addChildCoordinator(storeCoordinator)
//        self.rootViewController.present(storeCoordinator.rootViewController,
//                                        animated: true, completion: nil)
    }
    
    func menuViewControllerDidTapBranchButton(menuViewController: MenuViewController) {
//        let branchCoordinator = BranchCoordinator()
//        branchCoordinator.delegate = self
//        branchCoordinator.start()
//        self.addChildCoordinator(branchCoordinator)
//        self.rootViewController.present(branchCoordinator.rootViewController,
//                                        animated: true, completion: nil)
    }
}

// MARK: ALUCoordinatorDelegate
extension AppCoordinator: ALUCoordinatorDelegate {
    func aluCoordinatorDidRequestCancel(aluCoordinator: ALUCoordinator) {
        aluCoordinator.rootViewController.dismiss(animated: true)
        self.removeChildCoordinator(aluCoordinator)
    }
    
    func aluCoordinator(aluCoordinator: ALUCoordinator, payload: ALUCoordinatorPayload) {
    }
}

//// MARK: LoadCoordinatorDelegate
//extension AppCoordinator: LoadCoordinatorDelegate {
//    func loadCoordinatorDidRequestCancel(loadCoordinator: LoadCoordinator) {
//        loadCoordinator.rootViewController.dismiss(animated: true)
//        self.removeChildCoordinator(loadCoordinator)
//    }
//
//    func loadCoordinator(loadCoordinator: LoadCoordinator, payload: LoadCoordinatorPayload) {
//
//    }
//}
//
//// MARK: StoreCoordinatorDelegate
//extension AppCoordinator: StoreCoordinatorDelegate {
//    func storeCoordinatorDidRequestCancel(storeCoordinator: StoreCoordinator) {
//        storeCoordinator.rootViewController.dismiss(animated: true)
//        self.removeChildCoordinator(storeCoordinator)
//    }
//
//    func storeCoordinator(storeCoordinator: StoreCoordinator, payload: StoreCoordinatorPayload) {
//
//    }
//}
//
//// MARK: BranchCoordinatorDelegate
//extension AppCoordinator: BranchCoordinatorDelegate {
//    func branchCoordinatorDidRequestCancel(branchCoordinator: BranchCoordinator) {
//        branchCoordinator.rootViewController.dismiss(animated: true)
//        self.removeChildCoordinator(branchCoordinator)
//    }
//
//    func branchCoordinator(aluCoordinator: BranchCoordinator, payload: BranchCoordinatorPayload) {
//    }
//}
