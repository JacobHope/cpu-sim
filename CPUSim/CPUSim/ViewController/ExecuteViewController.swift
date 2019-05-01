//
//  ExecuteViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import UIKit

public protocol ExecuteViewControllerDelegate: class {
    func executeViewControllerOnTouchesBegan(_ executeViewController: ExecuteViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func executeViewControllerOnTouchesMoved(_ executeViewController: ExecuteViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func executeViewControllerOnTouchesEnded(_ executeViewController: ExecuteViewController)
    func executeViewControllerOnTouchesCancelled(_ executeViewController: ExecuteViewController)
    func executeViewControllerClearDrawing(_ executeViewController: ExecuteViewController)
    func executeViewControllerSetup(_ executeViewController: ExecuteViewController)
    func evcViewWillAppear(_ mavc: ExecuteViewController)
    func evcViewWillDisappear(_ evc: ExecuteViewController)
    func executeViewControllerDidSwipeLeft(_ executeViewController: ExecuteViewController)
    func executeViewControllerDidSwipeRight(_ executeViewController: ExecuteViewController)
    func executeViewController(_ executeViewController: ExecuteViewController)
}

public class ExecuteViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var ExecuteView: UIView!
    @IBOutlet weak var drawingImageView: UIImageView!

    // MARK: Tab bar
    @IBOutlet weak var exIdTab: TouchTabView!
    @IBOutlet weak var exMemTab: TouchTabView!

    // MARK: Progress view
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: exIdAddToAdd
    @IBOutlet weak var exIdAddToAddStart: TouchPointView!
    @IBOutlet weak var exIdAddToAddEnd: TouchPointView!
    @IBOutlet weak var exIdAddToAdd1: LineView!

    // MARK: exShiftLeftToAdd
    @IBOutlet weak var exShiftLeftToAddStart: TouchPointView!
    @IBOutlet weak var exShiftLeftToAddEnd: TouchPointView!
    @IBOutlet weak var exShiftLeftToAdd1: LineView!

    // MARK: exAluToMem
    @IBOutlet weak var exAluToMemStart: TouchPointView!
    @IBOutlet weak var exAluToMemEnd: TouchPointView!
    @IBOutlet weak var exAluToMem1: LineView!

    // MARK: exIdSignExtendToShiftLeft
    @IBOutlet weak var exIdSignExtendToShiftLeftStart: TouchPointView!
    @IBOutlet weak var exIdSignExtendToShiftLeftEnd: TouchPointView!
    @IBOutlet weak var exIdSignExtendToShiftLeft1: LineView!
    @IBOutlet weak var exIdSignExtendToShiftLeft2: LineView!
    @IBOutlet weak var exIdSignExtendToShiftLeft3: LineView!

    // MARK: exIdSignExtendToMux
    @IBOutlet weak var exIdSignExtendToMuxEnd: TouchPointView!
    @IBOutlet weak var exIdSignExtendToMux1: LineView!
    @IBOutlet weak var exIdSignExtendToMux2: LineView!
    @IBOutlet weak var exIdSignExtendToMux3: LineView!

    // MARK: exIdReadDataOneToAlu
    @IBOutlet weak var exIdReadDataOneToAluStart: TouchPointView!
    @IBOutlet weak var exIdReadDataOneToAluEnd: TouchPointView!
    @IBOutlet weak var exIdreadDataOneToAlu1: LineView!

    // MARK: exIdReadDataTwoToMux
    @IBOutlet weak var exIdReadDataTwoToMuxStart: TouchPointView!
    @IBOutlet weak var exIdReadDataTwoToMuxEnd: TouchPointView!
    @IBOutlet weak var exIdReadDataTwoToMux1: LineView!
    @IBOutlet weak var exIdReadDataTwoToMux2: LineView!
    @IBOutlet weak var exIdReadDataTwoToMux3: LineView!
    @IBOutlet weak var exIdReadDataTwoToMux4: LineView!
    @IBOutlet weak var exIdReadDataTwoToMux5: LineView!

    // MARK: exMuxToAlu
    @IBOutlet weak var exMuxToAluStart: TouchPointView!
    @IBOutlet weak var exMuxToAluEnd: TouchPointView!
    @IBOutlet weak var exMuxToAlu1: LineView!
    
    // MARK: exMuxMemToEx
    @IBOutlet weak var exMuxMemToExStart: TouchPointView!
    @IBOutlet weak var exMuxMemToExEnd: TouchPointView!
    @IBOutlet weak var exMuxMemToEx1: LineView!
    
    // MARK: exAddToMem
    @IBOutlet weak var exAddToMemStart: TouchPointView!
    @IBOutlet weak var exAddToMemEnd: TouchPointView!
    @IBOutlet weak var exAddToMem1: LineView!
    
    public weak var delegate: ExecuteViewControllerDelegate?

    var touchPoints: [TouchPointView] = []
    var lines: [String: [LineView]] = [:]

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
        leftSwipe.cancelsTouchesInView = false
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        rightSwipe.cancelsTouchesInView = false

        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        // Disable Pop Gestures
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        // Finish setting up
        self.delegate?.executeViewControllerSetup(self)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        delegate?.evcViewWillDisappear(self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        delegate?.evcViewWillAppear(self)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.executeViewControllerOnTouchesBegan(self, touches, with: event)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.executeViewControllerOnTouchesMoved(self, touches, with: event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.executeViewControllerOnTouchesEnded(self)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.executeViewControllerOnTouchesCancelled(self)
    }

    @objc private func swiped(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.executeViewControllerDidSwipeRight(self)
        }

        if (sender.direction == .right) {
            self.delegate?.executeViewControllerDidSwipeLeft(self)
        }
    }
}
