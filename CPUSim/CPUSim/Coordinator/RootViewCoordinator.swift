//
//  RootViewCoordinator.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/28/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

public typealias RootViewCoordinator = Coordinator & RootViewControllerProvider
