//
//  SplashViewController.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/28/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

public protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTapALUButton(menuViewController: MenuViewController)
    func menuViewControllerDidTapLoadButton(menuViewController: MenuViewController)
    func menuViewControllerDidTapStoreButton(menuViewController: MenuViewController)
    func menuViewControllerDidTapBranchButton(menuViewController: MenuViewController)
}

public class MenuViewController: UIViewController {
    
    // MARK: Properties
    public weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet var MenuView: UIView!
    @IBOutlet weak var ALUButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var branchButton: UIButton!
    
    // MARK: Init
    public init() {
        super.init(nibName: "MenuView", bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure ALU Button
        ALUButton.format()
        ALUButton.addTarget(self, action: #selector(didTapALUButton), for: UIControl.Event.touchUpInside)
        
        // Configure Load Button
        loadButton.format()
        loadButton.addTarget(self, action: #selector(didTapLoadButton), for: UIControl.Event.touchUpInside)
        
        // Configure Store Button
        storeButton.format()
        storeButton.addTarget(self, action: #selector(didTapStoreButton), for: UIControl.Event.touchUpInside)
        
        // Configure Branch Button
        branchButton.format()
        branchButton.addTarget(self, action: #selector(didTapBranchButton), for: UIControl.Event.touchUpInside)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func updateView() {
    }

    @objc private func didTapALUButton(sender: UIButton) {
        self.delegate?.menuViewControllerDidTapALUButton(menuViewController: self)
    }
    @objc private func didTapLoadButton(sender: UIButton) {
        self.delegate?.menuViewControllerDidTapLoadButton(menuViewController: self)
    }
    @objc private func didTapStoreButton(sender: UIButton) {
        self.delegate?.menuViewControllerDidTapStoreButton(menuViewController: self)
    }
    @objc private func didTapBranchButton(sender: UIButton) {
        self.delegate?.menuViewControllerDidTapBranchButton(menuViewController: self)
    }
}

// MARK: UIButton Custom Design
extension UIButton {
    func format(){
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = self.frame.height / 6
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
