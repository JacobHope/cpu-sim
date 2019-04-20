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
    @IBOutlet weak var idExTouchTab: TouchTabView!
    @IBOutlet weak var idIFTouchTab: TouchTabView!
    @IBOutlet weak var idExToWriteDataEnd: TouchPointView!
    @IBOutlet weak var idIFToReadAddress1End: TouchPointView!
    @IBOutlet weak var idIFToReadAddress2End: TouchPointView!
    @IBOutlet weak var idIFToSignExtendEnd: TouchPointView!
    @IBOutlet weak var idIFToMux0End: TouchPointView!
    @IBOutlet weak var idIFToMux1End: TouchPointView!
    @IBOutlet weak var idMuxToWriteAddressStart: TouchPointView!
    @IBOutlet weak var idMuxToWriteAddressEnd: TouchPointView!
    @IBOutlet weak var idReadData1ToExStart: TouchPointView!
    @IBOutlet weak var idReadData2ToExStart: TouchPointView!
    @IBOutlet weak var idSignExtendToExStart: TouchPointView!
    
    
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
