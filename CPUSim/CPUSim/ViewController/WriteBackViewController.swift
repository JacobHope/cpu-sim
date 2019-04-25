//
//  WriteBackViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/4/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol WriteBackViewControllerDelegate: class {
    func writeBackViewControllerOnTouchesBegan(_ writeBackViewController: WriteBackViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func writeBackViewControllerOnTouchesMoved(_ writeBackViewController: WriteBackViewController, _ touches: Set<UITouch>, with event: UIEvent?)
    func writeBackViewControllerOnTouchesEnded(_ writeBackViewController: WriteBackViewController)
    func writeBackViewControllerOnTouchesCancelled(_ writeBackViewController: WriteBackViewController)
    func writeBackViewControllerClearDrawing(_ writeBackViewController: WriteBackViewController)
    func writeBackViewControllerSetup(_ writeBackViewController: WriteBackViewController)
    func wbvcViewWillDisappear(_ wbvc: WriteBackViewController)
    
    func writeBackViewControllerDidSwipeLeft(_ writeBackViewController: WriteBackViewController)
    func writeBackViewControllerDidSwipeRight(_ writeBackViewController: WriteBackViewController)
    
    func writeBackViewControllerDidTapDone(_ writeBackViewController: WriteBackViewController)
    func writeBackViewController(_ writeBackViewController: WriteBackViewController)
}

public class WriteBackViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var WriteBackView: UIView!
    @IBOutlet weak var drawingImageView: UIImageView!
    
    // MARK: Tab bar
    @IBOutlet weak var wbMemTab: TouchTabView!
    
    // MARK: Progress view
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: WBMEMReadDataToMUX
    @IBOutlet weak var wbMemReadDataToMuxStart: TouchPointView!
    @IBOutlet weak var wbMemReadDataToMuxEnd: TouchPointView!
    @IBOutlet weak var wbMemReadDataToMux1: LineView!
    
    // MARK: WBMEMAddressToMux
    @IBOutlet weak var wbMemAddressToMuxStart: TouchPointView!
    @IBOutlet weak var wbMemAddressToMuxEnd: TouchPointView!
    @IBOutlet weak var wbMemAddressToMux1: LineView!
    
    // MARK: WBMUXToIFWriteData
    @IBOutlet weak var wbMuxToIfWriteDataStart: TouchPointView!
    @IBOutlet weak var wbMuxToIfWriteDataEnd: TouchPointView!
    @IBOutlet weak var wbMuxToIfWriteData1: LineView!
    @IBOutlet weak var wbMuxToIfWriteData2: LineView!
    @IBOutlet weak var wbMuxToIfWriteData3: LineView!
    
    // MARK: WBMEMToIFWriteAddress
    @IBOutlet weak var wbMemToIfWriteAddressStart: TouchPointView!
    @IBOutlet weak var wbMemToIfWriteAddressEnd: TouchPointView!
    @IBOutlet weak var wbMemToIfWriteAddress1: LineView!
    @IBOutlet weak var wbMemToIfWriteAddress2: LineView!
    @IBOutlet weak var wbMemToIfWriteAddress3: LineView!
    
    public weak var delegate: WriteBackViewControllerDelegate?
    
    var touchPoints: [TouchPointView] = []
    var lines: [String: [LineView]] = [:]
    
    //MARK: Properties - Navigation Bar Items
    
    lazy var doneBarButtonItem: UIBarButtonItem = {
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        return doneBarButtonItem
    }()
    
    // MARK: Init
    public init() {
        super.init(nibName: "WriteBackView", bundle: nil)
        
        self.title = "Write Back"
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
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
        
        // Disable Pop Gestures
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // Finish setting up
        self.delegate?.writeBackViewControllerSetup(self)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        delegate?.wbvcViewWillDisappear(self)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.writeBackViewControllerOnTouchesBegan(self, touches, with: event)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.writeBackViewControllerOnTouchesMoved(self, touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.writeBackViewControllerOnTouchesEnded(self)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.writeBackViewControllerOnTouchesCancelled(self)
    }
    
    @objc private func doneButtonTapped(sender: UIBarButtonItem) {
        self.delegate?.writeBackViewControllerDidTapDone(self)
    }
    
    @objc func swiped(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.delegate?.writeBackViewControllerDidSwipeRight(self)
        }
        
        if (sender.direction == .right) {
            self.delegate?.writeBackViewControllerDidSwipeLeft(self)
        }
    }
}
