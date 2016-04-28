//
//  ShoppingTableViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-13.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Firebase

class ShoppingTableViewController: UITableViewController {

    
    var houseHoldItemList: [HouseHoldItem] = []
    var houseHoldItemsLowLimmit: [HouseHoldItem] = []
    var houseHold: String!
    var houseHoudls: [HouseHold] = []
    
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
    
    @IBOutlet weak var shopItemLabel: UINavigationItem!
    @IBOutlet var houseHoldList: UITableView!
    @IBOutlet weak var menyButton: UIBarButtonItem!
    override func viewWillAppear(animated: Bool) {
        
        fireService.getHouseHoldLists({
            
            }, completion: {house in
                self.houseHoldItemsLowLimmit.removeAll()
                var count: Int = 0
                
                self.houseHoudls = house
                for i in self.houseHoudls {
                    count += 1
                    if(i.houseHoldName == self.houseHold) {
                        break
                    }
                }
                if(count != 0) {
                self.houseHoldItemList = self.houseHoudls[(count - 1)].houseHoldList
                self.indexLimmit(self.houseHoldItemList)
                self.houseHoldList.reloadData()
                }
        })

        
        
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
