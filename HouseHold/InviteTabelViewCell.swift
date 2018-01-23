//
//  InviteTabelViewCell.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-08-30.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit

class InviteTabelViewCell: UITableViewCell {
    
   
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var inviteAcceptButton: UIButton!
    @IBOutlet weak var inviteDeleteButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
