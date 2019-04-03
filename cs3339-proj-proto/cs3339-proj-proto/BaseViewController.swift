//
//  BaseViewController.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit
import Pulsator

protocol ViewControllerDelegate: class {
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func onTouchesEnded()
    func onTouchesCancelled()
}

class BaseViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?

    // MARK: UIKit

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouchesEnded()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouchesCancelled()
    }
}
