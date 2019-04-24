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
//
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
    weak var drawingImageView: UIImageView!

    // MARK: Properties - Complete button
    //weak var completeButton: GlowingButton!

    // MARK: Properties - Tab View
    //weak var ifIdTab: TouchTabView!
    @IBOutlet weak var idIfTab: TouchTabView!
    @IBOutlet weak var idExTab: TouchTabView!
    
    // MARK: ProgressView
    //weak var progressView: UIProgressView!
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: Properties - idExToWriteData
    @IBOutlet weak var idExToWriteDataEnd: TouchPointView!
    @IBOutlet weak var idExToWriteDataStart: TouchPointView!
    @IBOutlet weak var idExToWriteData1: LineView!
    @IBOutlet weak var idExToWriteData2: LineView!
    @IBOutlet weak var idExToWriteData3: LineView!
    
    // MARK: Properties - idIfToEx
    @IBOutlet weak var idIfToExStart: TouchPointView!
    @IBOutlet weak var idIfToExEnd: TouchPointView!
    @IBOutlet weak var idIfToEx1: LineView!
    
    // MARK: Properties - idIfStart
    @IBOutlet weak var idIfStart: TouchPointView!
    @IBOutlet weak var idIf1: LineView!
    
    // MARK: Properties - idIfToReadAddress1
    // idIFStart is start touch point
    @IBOutlet weak var idIfToReadAddress1End: TouchPointView!
    // idIf1 is first line view
    @IBOutlet weak var idIfToReadAddress1_1: LineView!
    @IBOutlet weak var idIfToReadAddress1_2: LineView!
    @IBOutlet weak var idIfToReadAddress1_3: LineView!
    
    // MARK: Properties - idIfToReadAddress2
    // idIfStart is start touch point
    @IBOutlet weak var idIfToReadAddress2End: TouchPointView!
    @IBOutlet weak var idIfToReadAddress2_1: LineView!
    // idIf1 is first line view
    @IBOutlet weak var idIfToReadAddress2_2: LineView!
    @IBOutlet weak var idIfToReadAddress2_3: LineView!
    
    // MARK: Properties - idIfToMux0
    // idIfStart is start touch point
    @IBOutlet weak var idIfToMux0End: TouchPointView!
    // idIf1 is first line view
    @IBOutlet weak var idIfToMux0_1: LineView!
    @IBOutlet weak var idIfToMux0_2: LineView!
    @IBOutlet weak var idIfToMux0_3: LineView!
    
    // MARK: Properties - idIfToMux1
    // idIfStart is start touch point
    @IBOutlet weak var idIfToMux1End: TouchPointView!
    // idIf1 is first line view
    @IBOutlet weak var idIfToMux1_1: LineView!
    @IBOutlet weak var idIfToMux1_2: LineView!
    @IBOutlet weak var idIfToMux1_3: LineView!
    
    // MARK: Properties - idIfToSignExtend
    // idIfStart is start touch point
    @IBOutlet weak var idIfToSignExtendEnd: TouchPointView!
    // idIf1 is first line view
    @IBOutlet weak var idIfToSignExtend1: LineView!
    @IBOutlet weak var idIfToSignExtend2: LineView!
    @IBOutlet weak var idIfToSignExtend3: LineView!
    
    // MARK: Properties - idMuxToWriteAddress
    @IBOutlet weak var idMuxToWriteAddressStart: TouchPointView!
    @IBOutlet weak var idMuxToWriteAddressEnd: TouchPointView!
    @IBOutlet weak var idMuxToWriteAddress1: LineView!
    @IBOutlet weak var idMuxToWriteAddress2: LineView!
    @IBOutlet weak var idMuxToWriteAddress3: LineView!
   
    // MARK: Properties - idReadData1ToEx
    @IBOutlet weak var idReadData1ToExStart: TouchPointView!
    @IBOutlet weak var idReadData1ToExEnd: TouchPointView!
    @IBOutlet weak var idReadData1ToEx1: LineView!
    @IBOutlet weak var idReadData1ToEx2: LineView!
    
    // MARK: Properties - idReadData2ToEx
    @IBOutlet weak var idReadData2ToExStart: TouchPointView!
    @IBOutlet weak var idReadData2ToExEnd: TouchPointView!
    @IBOutlet weak var idReadData2ToEx1: LineView!
    @IBOutlet weak var idReadData2ToEx2: LineView!
    
    // MARK: Properties - idSignExtendToEx
    @IBOutlet weak var idSignExtendToExStart: TouchPointView!
    @IBOutlet weak var idSignExtendToExEnd: TouchPointView!
    @IBOutlet weak var idSignExtendToEx1: LineView!
    @IBOutlet weak var idSignExtendToEx2: LineView!

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
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.delegate?.decodeViewControllerOnTouchesBegan(self, touches, with: event)
//    }
//
//    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.delegate?.decodeViewControllerOnTouchesMoved(self, touches, with: event)
//    }
//
//    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.delegate?.decodeViewControllerOnTouchesEnded(self)
//    }
//
//    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.delegate?.decodeViewControllerOnTouchesCancelled(self)
//    }

    @objc private func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.decodeViewControllerDidSwipeRight(self)
        }

        if (sender.direction == .right) {
            self.delegate?.decodeViewControllerDidSwipeLeft(self)
        }
    }
}
