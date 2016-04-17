//
//  FirebaseService.swift
//  roberttodo
//
//  Created by Robert Andersson on 2016-04-08.
//  Copyright © 2016 Robert Karlsson. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    let root: Firebase
    var autID:String? {return root.authData.uid}
    
    //Endpoint
    
    var users: Firebase {return root.childByAppendingPath("users") }
    var items: Firebase {return root.childByAppendingPath("items") }
    
    init(rootRef: String) {
    
        root = Firebase(url: rootRef)
    }
    
    func regisreUserWhitEmail(email: String, password: String, completion: (Bool) -> Void) {
    
        root.createUser(email, password: password) { (error: NSError!, result: [NSObject: AnyObject]!) in
            
            guard error == nil else {
                print("It did not work")
                print(error.description)
                completion(false)
            return
            }
            print(email)
            print("User registered")
            self.users.childByAppendingPath(result["uid"] as! String).setValue(["email": email])
            completion(true)
        }
        
    }
    
    func loginUserWhitEmail(email: String, password: String, completion: (Bool) -> Void) {
    
        root.authUser(email, password: password) { (error: NSError!, authData: FAuthData!) in
        
            guard error == nil else {
                print("It did not work")
                completion(false)
                return
            }
            completion(true)
            print("User")
        }
    
    }
    
}
