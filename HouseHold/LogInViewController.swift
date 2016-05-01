//
//  LogInViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-10.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
   
    @IBOutlet weak var menyButton: UIBarButtonItem!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if let email = emailTextfield.text, password = passwordTextfield.text {
            
            fireService.loginUserWhitEmail(email, password: password) {(passed: Bool) in
                
                if passed == true {
                
                    self.performSegueWithIdentifier("menu", sender: sender)
                    

                } else  {
                    print("Fel")
                    
                }
                
            }
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
     
        /*let VC = segue.destinationViewController as! MenuViewController
        
        VC.userInloggdEmail = emailTextfield.text*/
        
    }
    

}
