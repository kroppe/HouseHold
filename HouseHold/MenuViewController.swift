//
//  MenuViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-13.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Foundation

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentIndex: Int = 0
    var houseHoudls: [HouseHold] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        houseHoudls.append(HouseHold(household: "Hemma"))
        houseHoudls.append(HouseHold(household: "Sommar hus"))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Korv", inventory: 2, inventoryLimit: 1))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Ägg", inventory: 3, inventoryLimit: 3))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Korv", inventory: 1, inventoryLimit: 1))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Mjölk", inventory: 4, inventoryLimit: 1))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Smör", inventory: 2, inventoryLimit: 1))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Grädde", inventory: 1, inventoryLimit: 1))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Gurka", inventory: 2, inventoryLimit: 1))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Tomater", inventory: 2, inventoryLimit: 3))
        houseHoudls[0].houseHoldList.append(HouseHoldItem(name: "Mjöl", inventory: 1, inventoryLimit: 1))
        houseHoudls[1].houseHoldList.append(HouseHoldItem(name: "Grädde", inventory: 1, inventoryLimit: 1))
        houseHoudls[1].houseHoldList.append(HouseHoldItem(name: "Gurka", inventory: 2, inventoryLimit: 1))
        houseHoudls[1].houseHoldList.append(HouseHoldItem(name: "Tomater", inventory: 2, inventoryLimit: 3))
        houseHoudls[1].houseHoldList.append(HouseHoldItem(name: "Mjöl", inventory: 1, inventoryLimit: 1))
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return houseHoudls.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseHolds Cell", forIndexPath: indexPath)
        
        
        cell.textLabel?.text = houseHoudls[indexPath.row].houseHoldName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        currentIndex = (indexPath?.row)!
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "ShoppingList" {
            let nav = segue!.destinationViewController as! UINavigationController
            let VC = nav.topViewController as! ShoppingTableViewController
            
            VC.houseHoldItemList = self.houseHoudls[currentIndex].houseHoldList
            
        }
        
        if segue!.identifier == "HouseHoldList" {
            let nav = segue!.destinationViewController as! UINavigationController
            let VC = nav.topViewController as! HouseHoldListViewController
            
            VC.houseHoldItemList = self.houseHoudls[currentIndex].houseHoldList
            
        }

        
    }
    
}
