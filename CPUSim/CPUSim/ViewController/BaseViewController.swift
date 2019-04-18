//
//  BaseViewController.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

class BaseViewController: UIViewController {
    public weak var baseViewControllerDelegate: BaseViewControllerDelegate?

    // MARK: UIKit

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        baseViewControllerDelegate?.onTouchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        baseViewControllerDelegate?.onTouchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        baseViewControllerDelegate?.onTouchesEnded()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        baseViewControllerDelegate?.onTouchesCancelled()
    }
    
    // TODO add swipe left and right
}
