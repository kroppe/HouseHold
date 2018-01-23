//
//  Invite.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-08-26.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import Foundation
import UIKit

class Invite {
    
    var inviteFrom: String!
    var inviteHouseholdKey: String!
    
    init(inviteFrom: String, key: String) {
        
        self.inviteFrom = inviteFrom
        self.inviteHouseholdKey = key
        
    }

}