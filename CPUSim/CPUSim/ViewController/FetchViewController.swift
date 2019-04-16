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
    //MARK: Base Delegate Functions
    func fetchViewControllerOnTouchesBegan(_ fetchViewController: FetchViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func fetchViewControllerOnTouchesMoved(_ fetchViewController: FetchViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func fetchViewControllerOnTouchesEnded(_ fetchViewController: FetchViewController)
    func fetchViewControllerOnTouchesCancelled(_ fetchViewController: FetchViewController)
    func fetchViewControllerClearDrawing(_ fetchViewController: FetchViewController)
    func fetchViewControllerSetup()
    
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController)
    
    //MARK: Specific Fetch View Delegate Functions
    func fetchViewController(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController)
}

public class FetchViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var FetchView: UIView!
    @IBOutlet weak var drawingImageView: UIImageView! {
        get {
            return self.drawingImageView
        }
    }
    @IBOutlet weak var ifMuxToPc1: LineView!
    @IBOutlet weak var ifMuxToPc2: LineView!
    @IBOutlet weak var ifMuxToPc3: LineView!
    @IBOutlet weak var ifMuxToPcStart: TouchPointView!
    @IBOutlet weak var ifMuxToPcEnd: TouchPointView!
    
    public weak var delegate: FetchViewControllerDelegate?
    
    var touchPoints: [TouchPointView] = []
    var lines: [String: [LineView]] = [:]
    
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
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // Setup TouchPointViews
        touchPoints = [ifMuxToPcStart, ifMuxToPcEnd]
        
        // Setup lines
        lines["ifMuxToPc"] = [ifMuxToPc1, ifMuxToPc2, ifMuxToPc3]
        
        // Finish setting up
        delegate?.setup()
        
        // Set BaseViewController delegate
        baseViewControllerDelegate = delegate
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        baseViewControllerDelegate?.onTouchesBegan(touches, with: event)
//    }
//
//    @objc func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        baseViewControllerDelegate?.onTouchesMoved(touches, with: event)
//    }
//
//    @objc func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        baseViewControllerDelegate?.onTouchesEnded()
//    }
//
//    @objc func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        baseViewControllerDelegate?.onTouchesCancelled()
//    }
    
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
