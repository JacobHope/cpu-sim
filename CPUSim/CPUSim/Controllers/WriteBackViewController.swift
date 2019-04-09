//
//  WriteBackViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol WriteBackViewControllerDelegate: class {
    func writeBackViewControllerDidSwipeLeft(_ writeBackViewController: WriteBackViewController)
    func writeBackViewControllerDidSwipeRight(_ writeBackViewController: WriteBackViewController)
    func writeBackViewControllerDidTapDone(_ writeBackViewController: WriteBackViewController)
    func writeBackViewController(_ writeBackViewController: WriteBackViewController)
}

public class WriteBackViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var WriteBackView: UIView!
    
    private let services: Services
    public weak var delegate: WriteBackViewControllerDelegate?
    
    //MARK: Properties - Navigation Bar Items
    
    lazy var doneBarButtonItem: UIBarButtonItem = {
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        return doneBarButtonItem
    }()
    
    // MARK: Init
    public init(services: Services) {
        self.services = services
        super.init(nibName: "WriteBackView", bundle: nil)
        
        self.title = "Write Back"
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewDidLoad
    override public func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc private func doneButtonTapped(sender: UIBarButtonItem) {
        self.delegate?.writeBackViewControllerDidTapDone(self)
    }
    
    @objc func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.writeBackViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
            self.delegate?.writeBackViewControllerDidSwipeLeft(self)
        }
    }
}
