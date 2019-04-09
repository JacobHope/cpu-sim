////
////  GameViewCoordinator.swift
////  CPUSim
////
////  Created by Jacob Morgan Hope on 3/28/19.
////  Copyright © 2019 Jacob M. Hope. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol SimulationCoordinatorDelegate: class {
//
//    /// The user tapped the cancel button
//    func simulationCoordinatorDidRequestCancel(simulationCoordinator: SimulationCoordinator)
//
//    /// The user completed the order flow with the payload
//    func simulationCoordinator(simulationCoordinator: SimulationCoordinator, didAddOrder orderPayload: SimulationCoordinatorPayload)
//
//}
//
//class SimulationCoordinatorPayload {
//    var selectedDrinkType: String?
//    var selectedSnackType: String?
//}
//
//class SimulationCoordinator: RootViewCoordinator {
//
//    // MARK: Properties
//
//    let services: Services
//    var childCoordinators: [Coordinator] = []
//
//    var rootViewController: UIViewController {
//        return self.navigationController
//    }
//
//    weak var delegate: SimulationCoordinatorDelegate?
//
//    var orderPayload: SimulationCoordinatorPayload?
//
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
//        let simulationViewController = SimulationViewController(services: self.services)
//        simulationViewController.delegate = self
//        self.navigationController.viewControllers = [simulationViewController]
//    }
//}
//
//// MARK: SimulationControllerDelegate
//
//extension SimulationCoordinator: SimulationViewControllerDelegate {
//
//    func SimulationViewControllerDidTapClose(_ simulationViewController: SimulationViewController) {
//        self.delegate?.simulationCoordinatorDidRequestCancel(simulationCoordinator: self)
//    }
//
//    func simulationViewController(_ simulationViewController: SimulationViewController) {
//        //self.orderPayload = SimulationCoordinatorPayload()
//        //self.orderPayload?.selectedDrinkType = drinkType
//        //self.showSimulationViewController()
//    }
//
//}
