//
//  TouchBarView.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 4/20/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

// Glowing animation based on:
// https://stackoverflow.com/questions/44850058/need-a-glowing-animation-around-a-button

import UIKit
import Foundation

class TouchTabView: UIView {
    var duration : CGFloat = 3
    var cornerRadius : CGFloat = 5
    var maxGlowSize : CGFloat = 10
    var minGlowSize : CGFloat = 0
    
    var name: String = "touchTab"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentScaleFactor = UIScreen.main.scale
        self.layer.masksToBounds = false
        self.setup()
        self.startAnimation()
    }
    
    func hitTest(_ touch: UITouch, event: UIEvent?) -> UIView? {
        //TODO implement hit test for touch tab
        let hitView = UIView() //STUB
        return hitView
    }
    
    func setup() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = maxGlowSize
        self.layer.shadowOpacity = 1
    }
    
    func startAnimation() {
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = maxGlowSize
        layerAnimation.toValue = minGlowSize
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(duration/2)
        layerAnimation.fillMode = CAMediaTimingFillMode.forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        self.layer.add(layerAnimation, forKey: "glowingAnimation")
    }
    
    func setCorrect() {
        //TODO set tab to green
    }
    
    func setIncorrect() {
        //TODO set tab to dark red
    }
    
    func reset() {
       //TODO reset tab to blue
    }
    
    func stop() {
      //TODO stop glow
    }
}
