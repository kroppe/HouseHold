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
    var userHouseHoldList: [String] = []
    //Endpoint
    var users: Firebase {return root.childByAppendingPath("users") }
    
    
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
            
        }
    
    }
    
    
    func getHouseHoldLists(start: () -> (), completion: ([HouseHold])-> Void){
        
        let ref = root.childByAppendingPath("houseHolds")
        var houseHolds: [HouseHold] = []
        
        start()
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            houseHolds.removeAll()
            
            
            for rest in snapshot.children{
                
                    for i in snapshot.childSnapshotForPath((rest.key) as String!).childSnapshotForPath("users").children {
                        
                        
                        if(self.autID! == (i.value as String)) {
                        
                            houseHolds.append(HouseHold(household: (rest.key) as String!))
                           
                            
                            for item in snapshot.childSnapshotForPath((rest.key) as String!).childSnapshotForPath("items").children {
                                
                                let name = item.childSnapshotForPath("name").value as! String
                                let index = item.childSnapshotForPath("antal").value as! Int
                                let limit = item.childSnapshotForPath("minAntal").value as! Int
                                
                                houseHolds[houseHolds.count - 1].houseHoldList.append(HouseHoldItem(name: name, inventory: index, inventoryLimit: limit))
                                
                            }
                            break
                        }
                        
                        
                        
                    }
                
            }
            completion(houseHolds)
        })
        
    }

    func removeHouseHoldFromUser(houseHold: String) {
        let ref = root.childByAppendingPath("houseHolds").childByAppendingPath(houseHold).childByAppendingPath("users")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            for i in snapshot.children {
                if(self.autID! == (i.value as String)) {
                    ref.childByAppendingPath(i.key as String!).removeValue()
                }
            }
        })
    }
    
    
    func addHousHold(name: String){
        root.childByAppendingPath("houseHolds").childByAppendingPath(name).childByAppendingPath("users").childByAutoId().setValue(autID)
        //root.childByAppendingPath("houseHolds").childByAppendingPath(name).childByAppendingPath("items").childByAutoId().setValue("hejsan")
    }
    
    func addItemToHouseHould(houseHold: String, itemType: String, index: Int, limit: Int) {
        let item: HouseHoldItem = HouseHoldItem.init(name: itemType, inventory: index, inventoryLimit: limit)
        root.childByAppendingPath("houseHolds").childByAppendingPath(houseHold).childByAppendingPath("items").childByAutoId().setValue(item.toAnyObject())
        
    }
    
}
