//
//  StoryboardInstantiable.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 3/30/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype MyType
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> MyType
}
