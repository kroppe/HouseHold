//
//  RegistreringViewController.swift
//  HouseHold
//
//  Created by Robert Andersson on 2016-04-17.
//  Copyright © 2016 Kroppe. All rights reserved.
//

import UIKit
import Firebase

class RegistreringViewController: UIViewController {
    let fireService = FirebaseService(rootRef: "https://householdapp.firebaseio.com/")
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func registerButton(sender: AnyObject) {
        
        okButton.backgroundColor = UIColor.blueColor()
        if let email = emailTextfield.text, password = passwordTextfield.text {
            
            fireService.regisreUserWhitEmail(email, password: password) {
                
                (passed:Bool) in
                
                if passed == true {
                    self.okButton.backgroundColor = UIColor.greenColor()
                }
                else {
                    self.okButton.backgroundColor = UIColor.redColor()
                }
            }
        }

    }

}
