//
//  HouseHoldListViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-10.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Firebase

class HouseHoldListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var houseHoldItemList: [HouseHoldItem] = []
    var houseHold: String!
    var houseHoudls: [HouseHold] = []
    
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
    
    @IBOutlet weak var menyButton: UIBarButtonItem!
    @IBOutlet weak var houseHoldTableView: UITableView!
    @IBOutlet weak var houseHoldBarLabel: UINavigationItem!
    
    
    override func viewWillAppear(animated: Bool) {
        
        fireService.getHouseHoldLists({
            
            }, completion: {house in
                
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
                    self.houseHoldTableView.reloadData()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "addIHouseHoldItem" {
            let nav = segue!.destinationViewController as! UINavigationController
            let VC = nav.topViewController as! AddItemViewController
        
            VC.huoseHold = self.houseHold
        }
    }

    @IBAction func addItemButton(sender: AnyObject) {
        
        
        var nField: UITextField!
        var iField: UITextField!
        var lField: UITextField!
        
        func configurationTextField(textField: UITextField!)
        {
            
            textField.placeholder = "Enter itemName"
            nField = textField
            
        }
        
        func configurationTextField1(textField: UITextField!)
        {
            
            textField.placeholder = "Enter itemIndex"
            iField = textField
        }
        
        func configurationTextField2(textField: UITextField!)
        {
            
            textField.placeholder = "Enter itemIndexLimit"
            lField = textField
        }
        
        
        
        func handleCancel(alertView: UIAlertAction!)
        {
            print("Cancelled !!")
        }
        
        let alert = UIAlertController(title: "New item", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addTextFieldWithConfigurationHandler(configurationTextField1)
        alert.addTextFieldWithConfigurationHandler(configurationTextField2)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
            let name = nField.text
            let index = Int(iField.text!)
            let limit = Int(lField.text!)
            
            self.fireService.addItemToHouseHould(self.houseHold, itemType: name!, index: index!, limit: limit!)
        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })

    }

    
}
