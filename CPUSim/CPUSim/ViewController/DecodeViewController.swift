//
//  DecodeViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol DecodeViewControllerDelegate: class {
    // MARK: Base Delegate Functions
    func decodeViewControllerOnTouchesBegan(_ decodeViewController: DecodeViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func decodeViewControllerOnTouchesMoved(_ decodeViewController: DecodeViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func decodeViewControllerOnTouchesEnded(_ decodeViewController: DecodeViewController)
    func decodeViewControllerOnTouchesCancelled(_ decodeViewController: DecodeViewController)
    func decodeViewControllerClearDrawing(_ decodeViewController: DecodeViewController)
    func decodeViewControllerSetup(_ decodeViewController: DecodeViewController)
    func decodeViewControllerViewWillDisappear(_ dvc: DecodeViewController)
    func dvcViewWillAppear(_ dvc: DecodeViewController)
    
    // MARK: Base Delegate Functions - Swipe Handling
    func decodeViewControllerDidSwipeLeft(_ decodeViewController: DecodeViewController)
    func decodeViewControllerDidSwipeRight(_ decodeViewController: DecodeViewController)

    // MARK: Decode View Specific Delegate Functions
    func decodeViewController(_ decodeViewController: DecodeViewController)
    //TODO add back left UI nav bar button functionality...default settings causing BUG.
}

public class DecodeViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var DecodeView: UIView!

    var FetchView: UIView!
    
    @IBOutlet weak var drawingImageView: UIImageView!

    // MARK: Properties - Tab View
    @IBOutlet weak var idIfTab: TouchTabView!
    @IBOutlet weak var idExTab: TouchTabView!
    
    // MARK: ProgressView
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: Properties - idExToWriteData
    @IBOutlet weak var idExToWriteDataEnd: TouchPointView!
    @IBOutlet weak var idExToWriteDataStart: TouchPointView!
    
    // MARK: Properties - idIfToEx
    @IBOutlet weak var idIfToExStart: TouchPointView!
    @IBOutlet weak var idIfToExEnd: TouchPointView!
    
    // MARK: Properties - idIfStart
    @IBOutlet weak var idIfStart: TouchPointView!
    
    // MARK: Properties - idIfToReadAddress1
    // idIfStart is start touch point
    @IBOutlet weak var idIfToReadAddress1End: TouchPointView!
    
    // MARK: Properties - idIfToReadAddress2
    // idIfStart is start touch point
    @IBOutlet weak var idIfToReadAddress2End: TouchPointView!
    
    // MARK: Properties - idIfToMux0
    // idIfStart is start touch point
    @IBOutlet weak var idIfToMux0End: TouchPointView!
    
    // MARK: Properties - idIfToMux1
    // idIfStart is start touch point
    @IBOutlet weak var idIfToMux1End: TouchPointView!
    
    // MARK: Properties - idIfToSignExtend
    // idIfStart is start touch point
    @IBOutlet weak var idIfToSignExtendEnd: TouchPointView!
    
    // MARK: Properties - idMuxToWriteAddress
    @IBOutlet weak var idMuxToWriteAddressStart: TouchPointView!
    @IBOutlet weak var idMuxToWriteAddressEnd: TouchPointView!
   
    // MARK: Properties - idReadData1ToEx
    @IBOutlet weak var idReadData1ToExStart: TouchPointView!
    @IBOutlet weak var idReadData1ToExEnd: TouchPointView!
    
    // MARK: Properties - idReadData2ToEx
    @IBOutlet weak var idReadData2ToExStart: TouchPointView!
    @IBOutlet weak var idReadData2ToExEnd: TouchPointView!
    
    // MARK: Properties - idSignExtendToEx
    @IBOutlet weak var idSignExtendToExStart: TouchPointView!
    @IBOutlet weak var idSignExtendToExEnd: TouchPointView!

    var touchPoints: [TouchPointView] = []
    var lines: [String: [LineView]] = [:]
    
    weak var delegate: DecodeViewControllerDelegate?
    
    //MARK: Properties - Navigation Bar Items
    
    // MARK: Init
    public init() {
        super.init(nibName: "DecodeView", bundle: nil)
        
        self.title = "Decode"
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewDidLoad
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
        
        delegate?.decodeViewControllerSetup(self)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        delegate?.decodeViewControllerViewWillDisappear(self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        self.delegate?.dvcViewWillAppear(self)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.decodeViewControllerOnTouchesBegan(self, touches, with: event)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.decodeViewControllerOnTouchesMoved(self, touches, with: event)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.decodeViewControllerOnTouchesEnded(self)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.decodeViewControllerOnTouchesCancelled(self)
    }

    @objc private func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.decodeViewControllerDidSwipeRight(self)
        }

        if (sender.direction == .right) {
            self.delegate?.decodeViewControllerDidSwipeLeft(self)
        }
    }
}
