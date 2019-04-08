//
//  FetchViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol FetchViewControllerDelegate: class {
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController)
    func fetchViewController(_ fetchViewController: FetchViewController)
}

public class FetchViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var FetchView: UIView!
    
    private let services: Services
    public weak var delegate: FetchViewControllerDelegate?
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeButtonTapped))
        return closeBarButtonItem
    }()
    
    // MARK: Init
    public init(services: Services) {
        self.services = services
        super.init(nibName: "FetchView", bundle: nil)
        
        self.title = "Fetch"
        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem
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
    
    @objc private func closeButtonTapped(sender: UIBarButtonItem) {
        self.delegate?.fetchViewControllerDidTapClose(self)
    }
    
    @objc func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.fetchViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
             self.delegate?.fetchViewControllerDidSwipeLeft(self)
        }
    }
}
