//
//  GlowingButton.swift
//  CPUSim
//
//  Created by Connor Reid on 4/20/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

// Based on: https://stackoverflow.com/questions/44850058/need-a-glowing-animation-around-a-button

import UIKit

class GlowingButton: UIButton {
    var model: GlowingButtonModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentScaleFactor = UIScreen.main.scale
        self.layer.masksToBounds = false
    }
    
    func setup(_ model: GlowingButtonModel) {
        self.model = model
        
        self.layer.cornerRadius = model.cornerRadius
        self.layer.shadowPath = CGPath(
            roundedRect: self.bounds,
            cornerWidth: model.cornerRadius,
            cornerHeight: model.cornerRadius,
            transform: nil)
        self.layer.shadowColor = model.shadowColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = model.maxGlowSize
        self.layer.shadowOpacity = 1.0
        startAnimation()
    }
    
    func startAnimation() {
        let layerAnim = CABasicAnimation(keyPath: "shadowRadius")
        layerAnim.fromValue = model?.maxGlowSize
        layerAnim.toValue = model?.minGlowSize
        layerAnim.autoreverses = true
        layerAnim.isAdditive = false
        layerAnim.duration = CFTimeInterval(model?.animDuration ?? 0 / 2)
        layerAnim.fillMode = .forwards
        layerAnim.isRemovedOnCompletion = false
        layerAnim.repeatCount = .infinity
        self.layer.add(layerAnim, forKey: "glowingAnimation")
    }
}
