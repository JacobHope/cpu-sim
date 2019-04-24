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
    func decodeViewControllerDidSwipeLeft(_ decodeViewController: DecodeViewController)
    func decodeViewControllerDidSwipeRight(_ decodeViewController: DecodeViewController)
    func decodeViewController(_ decodeViewController: DecodeViewController)
}

public class DecodeViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var DecodeView: UIView!
    
    // MARK: Properties - Tab View
    @IBOutlet weak var idExTouchTab: TouchTabView!
    @IBOutlet weak var idIFTouchTab: TouchTabView!
    
    // MARK: Properties - idExToWriteData
    @IBOutlet weak var idExToWriteDataEnd: TouchPointView!
    @IBOutlet weak var idExToWriteDataStart: TouchPointView!
    @IBOutlet weak var idExToWriteData1: LineView!
    @IBOutlet weak var idExToWriteData2: LineView!
    @IBOutlet weak var idExToWriteData3: LineView!
    
    // MARK: Properties - idIfToEx
    //TODO create/connect start and end idIfToEx
    @IBOutlet weak var idIfToEx1: LineView!
    
    // MARK: Properties - idIfToReadAddress1
    @IBOutlet weak var idIfToReadAddress1End: TouchPointView!
    @IBOutlet weak var idIfToReadAddress1_1: LineView!
    @IBOutlet weak var idIfToReadAddress1_2: LineView!
    @IBOutlet weak var idIfToReadAddress1_3: LineView!
    
    // MARK: Properties - idIfToReadAddress2
    @IBOutlet weak var idIfToReadAddress2End: TouchPointView!
    @IBOutlet weak var idIfToReadAddress2_1: LineView!
    @IBOutlet weak var idIfToReadAddress2_2: LineView!
    @IBOutlet weak var idIfToReadAddress2_3: LineView!
    
    // MARK: Properties - idIfToMux0
    @IBOutlet weak var idIfToMux0End: TouchPointView!
    @IBOutlet weak var idIfToMux0_1: LineView!
    @IBOutlet weak var idIfToMux0_2: LineView!
    @IBOutlet weak var idIfToMux0_3: LineView!
    
    // MARK: Properties - idIfToMux1
    @IBOutlet weak var idIfToMux1End: TouchPointView!
    @IBOutlet weak var idIfToMux1_1: LineView!
    @IBOutlet weak var idIfToMux1_2: LineView!
    @IBOutlet weak var idIfToMux1_3: LineView!
    
    // MARK: Properties - idIfToSignExtend
    @IBOutlet weak var idIfToSignExtendEnd: TouchPointView!
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
    @IBOutlet weak var idReadData1ToEx1: LineView!
    @IBOutlet weak var idReadData1ToEx2: LineView!
    
    // MARK: Properties - idReadData2ToEx
    @IBOutlet weak var idReadData2ToExStart: TouchPointView!
    @IBOutlet weak var idReadData2ToEx1: LineView!
    @IBOutlet weak var idReadData2ToEx2: LineView!
    
    // MARK: Properties - idSignExtendToEx
    @IBOutlet weak var idSignExtendToExStart: TouchPointView!
    @IBOutlet weak var idSignExtendToEx1: LineView!
    @IBOutlet weak var idSignExtendToEx2: LineView!
    
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
            self.delegate?.decodeViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
            self.delegate?.decodeViewControllerDidSwipeLeft(self)
        }
    }
}
