//
//  FetchViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

protocol FetchViewControllerDelegate: class {
    //MARK: - Base Delegate Functions
    func fetchViewControllerOnTouchesBegan(_ fetchViewController: FetchViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func fetchViewControllerOnTouchesMoved(_ fetchViewController: FetchViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func fetchViewControllerOnTouchesEnded(_ fetchViewController: FetchViewController)
    func fetchViewControllerOnTouchesCancelled(_ fetchViewController: FetchViewController)
    func fetchViewControllerClearDrawing(_ fetchViewController: FetchViewController)
    func fetchViewControllerSetup(_ fetchViewController: FetchViewController)
    
    func fetchViewControllerDidSwipeLeft(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidSwipeRight(_ fetchViewController: FetchViewController)
    
    //MARK: Specific Fetch View Delegate Functions
    func fetchViewController(_ fetchViewController: FetchViewController)
    func fetchViewControllerDidTapClose(_ fetchViewController: FetchViewController)
}

class FetchViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var FetchView: UIView!
    @IBOutlet weak var drawingImageView: UIImageView!
    
    // MARK: ProgressView
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: IFMUXToPC
    @IBOutlet weak var ifMuxToPc1: LineView!
    @IBOutlet weak var ifMuxToPc2: LineView!
    @IBOutlet weak var ifMuxToPc3: LineView!
    @IBOutlet weak var ifMuxToPcStart: TouchPointView!
    @IBOutlet weak var ifMuxToPcEnd: TouchPointView!
    
    // MARK: IFPCToALU
    @IBOutlet weak var ifPcToAlu1: LineView!
    @IBOutlet weak var ifPcToAlu2: LineView!
    @IBOutlet weak var ifPcToAluStart: TouchPointView!
    @IBOutlet weak var ifPcToAluEnd: TouchPointView!
    
    // MARK: IFPCToIM
    @IBOutlet weak var ifPcToIm1: LineView!
    @IBOutlet weak var ifPcToImEnd: TouchPointView!
    
    // MARK: IFFourToALU
    @IBOutlet weak var ifFourToAluStart: TouchPointView!
    @IBOutlet weak var ifFourToAluEnd: TouchPointView!
    
    // MARK: IFALUToMUX
    @IBOutlet weak var ifAluToMuxStart: TouchPointView!
    @IBOutlet weak var ifAluToMuxEnd: TouchPointView!
    
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
        
        // Finish setting up
        self.delegate?.fetchViewControllerSetup(self)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.fetchViewControllerOnTouchesBegan(self, touches, with: event)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.fetchViewControllerOnTouchesMoved(self, touches, with: event)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.fetchViewControllerOnTouchesEnded(self)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.fetchViewControllerOnTouchesCancelled(self)
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
