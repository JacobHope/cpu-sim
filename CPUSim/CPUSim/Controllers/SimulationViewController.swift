//
//  GameViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/28/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit
import SpriteKit
//import GameplayKit

public protocol SimulationViewControllerDelegate: class {
    //func simulationViewControllerDidTapSimulate(simulationViewController: SimulationViewController)
}

// Note: Changed from GameViewController
public class SimulationViewController: UIViewController {
    
    private let services: Services
    
    public weak var delegate: SimulationViewControllerDelegate?
    
    public init(services: Services) {
        self.services = services
        super.init(nibName: nil, bundle: nil)
//
//        self.title = "Select Drink"
//        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        self.view = SKView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
}
