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
    var houseHoudls: [HouseHold] = []
    var inviteHouseholds: [Invite] = []
    var userInloggdEmail: String!
    var houseHoldKey: String!
    var houseHold: String!
    
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
            menyButton.action = #selector(SWRevealViewController.revealToggle(_:))
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseHoldList Cell", forIndexPath: indexPath) as! ItemListTableViewCell
        
        
        let item = houseHoldItemList[indexPath.row]
        cell.itemNameLabel.text = item.name
        cell.itemIndexLabel.text = "\(String(item.inventory)) / \(String(item.inventoryLimit))"
        cell.itemEditButton.tag = indexPath.row
        return cell
    }
    
    
    @IBAction func addItemButton(sender: AnyObject) {
        
        
        var nField: UITextField!
        var iField: UITextField!
        var lField: UITextField!
        
        func configurationTextField(textField: UITextField!)
        {
            
            textField.placeholder = "Produkter namn"
            nField = textField
            
        }
        
        func configurationTextField1(textField: UITextField!)
        {
            
            textField.placeholder = "Produkt antal"
            iField = textField
        }
        
        func configurationTextField2(textField: UITextField!)
        {
            
            textField.placeholder = "Produkter min-antal"
            lField = textField
        }
        
        
        
        func handleCancel(alertView: UIAlertAction!)
        {
            
        }
        
        let alert = UIAlertController(title: "Ny produkt", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addTextFieldWithConfigurationHandler(configurationTextField1)
        alert.addTextFieldWithConfigurationHandler(configurationTextField2)
        alert.addAction(UIAlertAction(title: "Avsluta", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Spara", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
            let name = nField.text
            let index = Int(iField.text!)
            let limit = Int(lField.text!)
            
            
                if(name! != "" && index != nil && limit != nil){
                    self.fireService.addItemToHouseHould(self.houseHoldKey, itemType: name!, index: index!, limit: limit!)
                }
                else {
                    self.alertMassageInvite("Fyll i alla textfält korekt")
                }
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })

    }

    @IBAction func editItemButton(sender: AnyObject) {
        
        var iField: UITextField!
        
        
        func configurationTextField(textField: UITextField!)
        {
            
            textField.placeholder = "Ta bort/Lägg produktantal"
            iField = textField
        }
        
        func handleCancel(alertView: UIAlertAction!)
        {
            
        }
        
        func deleteProdukt(alertView: UIAlertAction!) {
            
        
            self.fireService.removeItemFromHouseHold(self.houseHoldKey, itemName: self.houseHoldItemList[sender.tag].name)
        }
        
        let alert = UIAlertController(title: "Updatara produkt", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Avsluta", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:deleteProdukt))
        alert.addAction(UIAlertAction(title: "Spara", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
            
            let index = Int(iField.text!)
            let currenItemIndex = self.houseHoldItemList[sender.tag].inventory
            
            if(index != nil) {
                var newItemIndex = (index! + currenItemIndex)
                
                if(newItemIndex <= 0) {
                    newItemIndex = 0
                }
                
                self.fireService.updateItemIndex(self.houseHoldKey, itemName: self.houseHoldItemList[sender.tag].name, newIndex: newItemIndex)
                
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })

    }
    
    @IBAction func shareHouseHoldButton(sender: AnyObject) {
        
        if(self.houseHold != "nil"){
            
            var eField: UITextField!
        
        
            func configurationTextField(textField: UITextField!)
            {
            
                textField.placeholder = "Dela till, E-mail"
                eField = textField
            }
        
            func handleCancel(alertView: UIAlertAction!)
            {
            
            }
        
            let alert = UIAlertController(title: "Dela hushåll", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Avsluta", style: UIAlertActionStyle.Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Dela", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
                let eMail: String = eField.text!
            
            
                
                if(eMail != "") {
                
                    if(eMail != self.userInloggdEmail){
                    
                        self.fireService.checkUserInvitesAndHouseHolds(eMail, houseHoldkey: self.houseHoldKey, start: {
                    
                            }, completion: {foundInvite in
                            
                                if(foundInvite == false) {
                                
                                    self.fireService.shareHouseHoldWhitEmail(eMail, userInloggdEmail: self.userInloggdEmail, houseHoldkey: self.houseHoldKey,houseHold: self.houseHold, start: {
                             
                                    }, completion: {foundUser in
                             
                                        if(foundUser == true) {
                                            self.alertMassageInvite("Inbjudan till (\(eMail)) är skickat")
                                        }
                                        else {
                                            self.alertMassageInvite("Andvändar (\(eMail)) hittas inte")
                                        }
                                    
                                    })

                                }
                                else {
                                
                                    self.alertMassageInvite("Andvändaren har redan en inbjudan/hushållet")
                                }
                            
                        })

                    
                    }
                    else {
                    
                        self.alertMassageInvite("Du kan inte skicka invite till dig själv")
                    }
                    
                }
                else {
                
                    self.alertMassageInvite("Skriv någon email adress")
                }
            
            
            
            }))
                self.presentViewController(alert, animated: true, completion: {
            
                })
        }
        else {
                self.alertMassageInvite("Inget hushåll valt för att dela")
            }
    }
    
    func alertMassageInvite(text: String) {
        let alertController = UIAlertController(title: "", message:
        text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
}
