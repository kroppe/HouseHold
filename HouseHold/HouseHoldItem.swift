//
//  HouseHoldItem.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-03-15.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import Foundation
import UIKit

class HouseHoldItem {
    
    var name: String!
    var inventory: Int!
    var inventoryLimit: Int!
    var barCode: String!
    
    required convenience init(name: String, inventory: Int, inventoryLimit: Int) {
        
        self.init(name: name, inventory: inventory, inventoryLimit: inventoryLimit,  barCode: "nil")
        
    
    }
    
    required init(name: String, inventory: Int, inventoryLimit: Int, barCode: String) {
        
        self.name = name
        self.inventory = inventory
        self.inventoryLimit = inventoryLimit
        self.barCode = barCode
        
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "antal": inventory, "minAntal": inventoryLimit, "name": name
        ]
    }


    
}