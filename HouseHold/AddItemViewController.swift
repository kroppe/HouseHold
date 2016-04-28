//
//  AddItemViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-17.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController {
    
    
    @IBOutlet weak var itemTypeTextField: UITextField!
    @IBOutlet weak var itemIndexTextField: UITextField!
    @IBOutlet weak var itemLimitTextField: UITextField!
    
    var huoseHold: String!
    
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        print(huoseHold)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(sender: AnyObject) {
    
        
        var nField: UITextField!
        var iField: UITextField!
        var lField: UITextField!
        
        func configurationTextField(textField: UITextField!)
        {
            
            textField.placeholder = "Enter an itemName"
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
        
        let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addTextFieldWithConfigurationHandler(configurationTextField1)
        alert.addTextFieldWithConfigurationHandler(configurationTextField2)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            print("Done !!")
            print("Name : \(nField.text)")
            print("Index : \(iField.text)")
            print("IndexLimit : \(lField.text)")
        }))
        self.presentViewController(alert, animated: true, completion: {
            print("completion block")
        })
    }
        
        
        /*let name = itemTypeTextField.text
        let index = Int(itemIndexTextField.text!)
        let limit = Int(itemLimitTextField.text!)
        fireService.addItemToHouseHould(self.huoseHold, itemType: name!, index: index!, limit: limit!)
        */
    
    
}
