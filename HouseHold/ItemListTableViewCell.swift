//
//  ItemListTableViewCell.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-28.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var shoppingItemName: UILabel!
    @IBOutlet weak var shoppingItemIndex: UILabel!
    @IBOutlet weak var shoppingEditButton: UIButton!
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemIndexLabel: UILabel!
    @IBOutlet weak var itemEditButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
