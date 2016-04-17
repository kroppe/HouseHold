//
//  HouseHoldListViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-10.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit

class HouseHoldListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var houseHoldItemList: [HouseHoldItem] = []
    
    @IBOutlet weak var menyButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if self.revealViewController() != nil {
            menyButton.target = self.revealViewController()
            menyButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
   
        
        // Do any additional setup after loading the view.
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
        return houseHoldItemList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseHoldList Cell", forIndexPath: indexPath)
        
        
        let item = houseHoldItemList[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(String(item.inventory)) st"
        return cell
    }

    
}
