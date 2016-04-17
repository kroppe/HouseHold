//
//  HouseHold.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-14.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import Foundation
import UIKit

class HouseHold {
    
    var houseHoldName: String!
    var houseHoldList: [HouseHoldItem] = []
    
    
    init(household: String) {
        
        self.houseHoldName = household
        
    }
    
}