//
//  AppDelegate.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/28/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: self.window!, services: Services())
        self.appCoordinator.start()
        
        return true
    }
}
