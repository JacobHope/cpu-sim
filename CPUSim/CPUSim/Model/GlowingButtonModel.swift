//
//  GlowingButtonModel.swift
//  CPUSim
//
//  Created by Connor Reid on 4/20/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation
import UIKit

struct GlowingButtonModel {
    let animDuration: CGFloat
    let cornerRadius: CGFloat
    let maxGlowSize: CGFloat
    let minGlowSize: CGFloat
    let shadowColor: CGColor
    
    init(animDuration: CGFloat,
         cornerRadius: CGFloat,
         maxGlowSize: CGFloat,
         minGlowSize: CGFloat,
         shadowColor: CGColor) {
        self.animDuration = animDuration
        self.cornerRadius = cornerRadius
        self.maxGlowSize = maxGlowSize
        self.minGlowSize = minGlowSize
        self.shadowColor = shadowColor
    }
}
