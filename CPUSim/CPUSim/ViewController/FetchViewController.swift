//
//  FetchViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

protocol FetchViewControllerDelegate: ViewControllerDelegate {
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController)
    func fetchViewController(_ fetchViewController: FetchViewController)
}

class FetchViewController: BaseViewController {
    // MARK: Properties
    @IBOutlet var FetchView: UIView!
    @IBOutlet weak var drawingImageView: UIImageView!
    
    public weak var fetchViewControllerDelegate: FetchViewControllerDelegate?
    
    var touchPoints: [TouchPointView] = []
    var lines: [LineView] = []
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeButtonTapped))
        return closeBarButtonItem
    }()
    
    // MARK: Init
    public init() {
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
        leftSwipe.cancelsTouchesInView = false
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        rightSwipe.cancelsTouchesInView = false

        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        // Setup TouchPointViews
        
        // Setup lines
        
        fetchViewControllerDelegate?.setup()
        
        // Set BaseViewController delegate
        delegate = fetchViewControllerDelegate
    }
    
    @objc private func closeButtonTapped(sender: UIBarButtonItem) {
        self.fetchViewControllerDelegate?.fetchViewControllerDidTapClose(self)
    }
    
    @objc func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.fetchViewControllerDelegate?.fetchViewControllerDidSwipeRight(self)
        }

        if (sender.direction == .right) {
             self.fetchViewControllerDelegate?.fetchViewControllerDidSwipeLeft(self)
        }
    }
}
