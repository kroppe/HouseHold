//
//  PopoverInviteViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-08-29.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Firebase

class PopoverInviteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
    var inviteHouseholds: [Invite] = []
    
    @IBOutlet weak var inviteTabelView: UITableView!
    
    override func viewDidLoad() {
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
        
        return inviteHouseholds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Invite Cell", forIndexPath: indexPath) as! InviteTabelViewCell
        
        cell.inviteAcceptButton.tag = indexPath.row
        cell.inviteDeleteButton.tag = indexPath.row
        cell.inviteLabel.text = inviteHouseholds[indexPath.row].inviteFrom
        return cell
    }

    @IBAction func acceptInviteButton(sender: AnyObject) {
        
        fireService.acceptInvite(inviteHouseholds[sender.tag].inviteHouseholdKey)
        inviteHouseholds.removeAtIndex(sender.tag)
        self.inviteTabelView.reloadData()
        
        if (inviteHouseholds.count == 0) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    @IBAction func deleteInviteButton(sender: AnyObject) {
        
        fireService.deleteInvite(inviteHouseholds[sender.tag].inviteHouseholdKey)
        inviteHouseholds.removeAtIndex(sender.tag)
        self.inviteTabelView.reloadData()
        
        if (inviteHouseholds.count == 0) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
    }
    

}
