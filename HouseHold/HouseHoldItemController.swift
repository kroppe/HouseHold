//
//  HouseHoldItemController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-03-15.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit

class HouseHoldItemController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let item = HouseHoldItem(name: "olle", inventory: 3, inventoryLimit: 6)
        print(item.name)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
