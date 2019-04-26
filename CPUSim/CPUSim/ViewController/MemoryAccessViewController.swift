//
//  MemoryAccessViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol MemoryAccessViewControllerDelegate: class {
    func memoryAccessViewControllerOnTouchesBegan(_ memoryAccessViewController: MemoryAccessViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func memoryAccessViewControllerOnTouchesMoved(_ memoryAccessViewController: MemoryAccessViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func memoryAccessViewControllerOnTouchesEnded(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewControllerOnTouchesCancelled(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewControllerClearDrawing(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewControllerSetup(_ memoryAccessViewController: MemoryAccessViewController)
    func mavcViewWillDisappear(_ mavc: MemoryAccessViewController)
    func mavcViewWillAppear(_ mavc: MemoryAccessViewController)
    
    func memoryAccessViewControllerDidSwipeLeft(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewControllerDidSwipeRight(_ memoryAccessViewController: MemoryAccessViewController)
    func memoryAccessViewController(_ memoryAccessViewController: MemoryAccessViewController)
}

public class MemoryAccessViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var MemoryAccessView: UIView!
    @IBOutlet weak var drawingImageView: UIImageView!
    
    // MARK: Tab bar
    @IBOutlet weak var memExTab: TouchTabView!
    @IBOutlet weak var memWbTab: TouchTabView!
    
    // MARK: Progress view
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: MEMEXToAddress
    @IBOutlet weak var memExToAddressStart: TouchPointView!
    @IBOutlet weak var memExToAddressEnd: TouchPointView!
    @IBOutlet weak var memExToAddress1: LineView!
    @IBOutlet weak var memExToAddress2: LineView!
    @IBOutlet weak var memExToAddress3: LineView!
    @IBOutlet weak var memExToAddress4: LineView!
    @IBOutlet weak var memExToAddress5: LineView!
    
    // MARK: MEMEXToWriteData
    @IBOutlet weak var memExtoWriteDataStart: TouchPointView!
    @IBOutlet weak var memExToWriteDataEnd: TouchPointView!
    @IBOutlet weak var memExToWriteData1: LineView!
    
    // MARK: MEMReadDataToWB
    @IBOutlet weak var memReadDataToWbStart: TouchPointView!
    @IBOutlet weak var memReadDataToWbEnd: TouchPointView!
    @IBOutlet weak var memReadDataToWb1: LineView!
    
    // MARK: MEMRegDstEXToWB
    @IBOutlet weak var memRegDstExToWbStart: TouchPointView!
    @IBOutlet weak var memRegDstExToWbEnd: TouchPointView!
    @IBOutlet weak var memRegDstExToWb1: LineView!
    
    // MARK: MEMRegDstWBToEX
    @IBOutlet weak var memRegDstWbToExStart: TouchPointView!
    @IBOutlet weak var memRegDstWbToExEnd: TouchPointView!
    @IBOutlet weak var memRegDstWbToEx1: LineView!
    
    // MARK: MEMMEMToRegWBToEX
    @IBOutlet weak var memMemToRegWbToExStart: TouchPointView!
    @IBOutlet weak var memMemToRegWbToExEnd: TouchPointView!
    @IBOutlet weak var memMemToRegWbToEx1: LineView!
    
    public weak var delegate: MemoryAccessViewControllerDelegate?
    
    var touchPoints: [TouchPointView] = []
    var lines: [String: [LineView]] = [:]
    
    // MARK: Init
    public init() {
        super.init(nibName: "MemoryAccessView", bundle: nil)
        
        self.title = "Memory Access"
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
        self.delegate?.memoryAccessViewControllerSetup(self)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        delegate?.mavcViewWillDisappear(self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        delegate?.mavcViewWillAppear(self)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.memoryAccessViewControllerOnTouchesBegan(self, touches, with: event)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.memoryAccessViewControllerOnTouchesMoved(self, touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.memoryAccessViewControllerOnTouchesEnded(self)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.memoryAccessViewControllerOnTouchesCancelled(self)
    }
    
    @objc private func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.memoryAccessViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
            self.delegate?.memoryAccessViewControllerDidSwipeLeft(self)
        }
    }
}
