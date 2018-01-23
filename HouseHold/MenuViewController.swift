//
//  MenuViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-13.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var newHouseHoldTextFiled: UITextField!
    @IBOutlet weak var addNewHouseHoldButton: UIButton!
    @IBOutlet weak var userLogInLabel: UILabel!
    @IBOutlet weak var houseHoldsTableView: UITableView!
    @IBOutlet weak var inviteButton: UIButton!
    
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
    var currentIndex: Int = 0
    var houseHoudls: [HouseHold] = []
    var inviteHouseholds: [Invite] = []
    var userInloggdEmail: String!
    
    override func viewWillAppear(animated: Bool) {
        fireService.getUserEmail({
            }, completion: {email in
                
                self.userInloggdEmail = email
        })
        
        navigationController?.navigationBar.hidden = true
    
        fireService.getHouseHoldLists({
            
            }, completion: {house in
                
                self.houseHoudls = house
                self.houseHoldsTableView.reloadData()
                                
        })
        
        fireService.getInviteHouseholds({
            
            }, completion: {invites in
                self.inviteButton.hidden = true
                self.inviteHouseholds = invites
                if(invites.count > 0) {
                    
                    self.inviteButton.hidden = false
                    
                }
                
                
        })

        
        
        
    }
    override func viewDidLoad() {
        newHouseHoldTextFiled.hidden = true
        addNewHouseHoldButton.hidden = true
        inviteButton.hidden = true
        
        super.viewDidLoad()
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseHolds Cell", forIndexPath: indexPath) as! MenuTableViewCell
        
        cell.deleteButton.tag = indexPath.row
        cell.cellLabel.text = houseHoudls[indexPath.row].houseHoldName
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
            
            VC.userInloggdEmail = self.userInloggdEmail
            if(houseHoudls.count == currentIndex) {
                
                currentIndex -= 1
            }
            
            if(houseHoudls.count != 0) {
                
                VC.houseHoldKey = self.houseHoudls[currentIndex].key
                VC.houseHold = self.houseHoudls[currentIndex].houseHoldName
                VC.shopItemLabel.title = self.houseHoudls[currentIndex].houseHoldName
                
            }else{
                
                VC.houseHoldKey = "nil"
                VC.houseHold = "nil"
            }
        }
        
        if segue!.identifier == "HouseHoldList" {
            let nav = segue!.destinationViewController as! UINavigationController
            let VC = nav.topViewController as! HouseHoldListViewController
            VC.userInloggdEmail = self.userInloggdEmail
            
            if(houseHoudls.count == currentIndex) {
                
                currentIndex -= 1
            }
                if(houseHoudls.count != 0) {
               
                    VC.houseHoldKey = self.houseHoudls[currentIndex].key
                    VC.houseHold = self.houseHoudls[currentIndex].houseHoldName
                    VC.houseHoldBarLabel.title = self.houseHoudls[currentIndex].houseHoldName
                    VC.inviteHouseholds = self.inviteHouseholds

                }else{
                    VC.houseHold = "nil"
                    VC.houseHoldKey = "nil"
                }
            
        }
        
        
    }
   
    
    @IBAction func addHouseholdButton(sender: AnyObject) {
        
        if(newHouseHoldTextFiled.hidden == true) {
            newHouseHoldTextFiled.hidden = false
            addNewHouseHoldButton.hidden = false
        }else {
            newHouseHoldTextFiled.hidden = true
            addNewHouseHoldButton.hidden = true
        }
    }
    
    @IBAction func addNewHouseHoldButton(sender: AnyObject) {
        var houseHoldfind: Bool = false
        if(newHouseHoldTextFiled.text! != ""){
            
            for house in houseHoudls {
                if (newHouseHoldTextFiled.text! == house.houseHoldName) {
                    
                    
                    houseHoldfind = true
                    break
                    
                }
                
            }
            
            if(houseHoldfind == false) {
                    
                    fireService.addHousHold(newHouseHoldTextFiled.text!)
                    newHouseHoldTextFiled.hidden = true
                    addNewHouseHoldButton.hidden = true
                    newHouseHoldTextFiled.text = ""

                }else{
                
                    let alertController = UIAlertController(title: "", message:
                    "Namnet (\(newHouseHoldTextFiled.text!)) andvänds redan", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                newHouseHoldTextFiled.text! = ""

            
        }
    }
    @IBAction func deleteHouseHoldButton(sender: AnyObject) {
        
        fireService.removeHouseHoldFromUser(self.houseHoudls[sender.tag].key)
       
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        fireService.logoutUser()
    }
    
    @IBAction func invitesButton(sender: AnyObject) {
        
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("PopoverInvite") as! PopoverInviteViewController
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(300, 200)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverVC.inviteHouseholds = self.inviteHouseholds
        }
        
        presentViewController(popoverVC, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

}
