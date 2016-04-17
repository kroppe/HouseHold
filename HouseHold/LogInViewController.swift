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
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
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
    

    @IBAction func loginButton(sender: AnyObject) {
        
        if let email = emailTextfield.text, password = passwordTextfield.text {
            print(email)
            fireService.loginUserWhitEmail(email, password: password) {(passed: Bool) in
                
                if passed == true {
                
                    print("OK")
                } else  {
                    print("Fel")
                    
                }
                
            }
        }

    }
   

}
