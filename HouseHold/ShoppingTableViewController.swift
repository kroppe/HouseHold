//
//  ShoppingTableViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-13.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit

class ShoppingTableViewController: UITableViewController {

    
    var houseHoldItemList: [HouseHoldItem] = []
    var houseHoldItemsLowLimmit: [HouseHoldItem] = []
    
    
    
    @IBOutlet weak var menyButton: UIBarButtonItem!
    override func viewWillAppear(animated: Bool) {
        
        
        indexLimmit(houseHoldItemList)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if self.revealViewController() != nil {
            menyButton.target = self.revealViewController()
            menyButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return houseHoldItemsLowLimmit.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Table Cell", forIndexPath: indexPath)

        let item = houseHoldItemsLowLimmit[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(String(item.inventory)) st"
        return cell
    }
    
    
    
    func indexLimmit(houseHoldList: [HouseHoldItem]) {
        
        for item in houseHoldList {
            
            if item.inventory <= item.inventoryLimit {
                houseHoldItemsLowLimmit.append(item)
              
            }
        }
        
        
    }

    
}
