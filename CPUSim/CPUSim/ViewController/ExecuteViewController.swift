//
//  ExecuteViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol ExecuteViewControllerDelegate: class {
    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController)
    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController)
    func executeViewController(_ executeViewController: ExecuteViewController)
}

public class ExecuteViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var ExecuteView: UIView!
    
    public weak var delegate: ExecuteViewControllerDelegate?
    
    // MARK: Init
    public init() {
        super.init(nibName: "ExecuteView", bundle: nil)
        
        self.title = "Execute"
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc private func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.executeViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
            self.delegate?.executeViewControllerDidSwipeLeft(self)
        }
    }
}
