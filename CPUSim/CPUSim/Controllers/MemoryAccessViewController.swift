//
//  MemoryAccessViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol MemoryAccessViewControllerDelegate: class {
    func memoryAccessViewControllerDidSwipeLeft(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewControllerDidSwipeRight(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewController(_ memoryAccessViewController: MemoryAccessViewController)
}

public class MemoryAccessViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var MemoryAccessView: UIView!
    
    private let services: Services
    public weak var delegate: MemoryAccessViewControllerDelegate?
    
    // MARK: Init
    public init(services: Services) {
        self.services = services
        super.init(nibName: "MemoryAccessView", bundle: nil)
        
        self.title = "Memory Access"
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
    }
    
    @objc private func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.memoryAccessViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
            self.delegate?.memoryAccessViewControllerDidSwipeLeft(self)
        }
    }
}
