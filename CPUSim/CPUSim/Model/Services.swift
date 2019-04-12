//
//  Services.swift
//  CPUSim
//
//  Created by Jacob Morgan Hope on 3/28/19.
//  Copyright © 2019 Jacob M. Hope. All rights reserved.
//

import Foundation

//TODO can this file be deleted?

public struct Services {
    
    public let dataService: DataService
    
    public init() {
        self.dataService = DataService()
    }
}

public struct Order {
    public let drinkType: String
    public let snackType: String
    
    public init(drinkType: String, snackType: String) {
        self.drinkType = drinkType
        self.snackType = snackType
    }
    
}

public class DataService {
    
    public var orders: [Order] = []
    
}
