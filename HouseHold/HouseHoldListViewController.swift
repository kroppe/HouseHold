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
    var houseHoldKey: String!
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
                let newItemIndex = (index! + currenItemIndex)
                self.fireService.updateItemIndex(self.houseHoldKey, itemName: self.houseHoldItemList[sender.tag].name, newIndex: newItemIndex)
                
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })

    }
    @IBAction func shareHouseHoldButton(sender: AnyObject) {
        
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
            
            let eMail = eField.text
            
            if(eMail != "") {
                self.fireService.shareHouseHoldWhitEmail(eMail!, houseHoldkey: self.houseHoldKey)
                
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            
        })
        
        
    

    }
    
}
