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
    
    func logoutUser() {
    
        
        
    }
    
    func getHouseHoldLists(start: () -> (), completion: ([HouseHold])-> Void){
        
        let ref = root.childByAppendingPath("houseHolds")
        var houseHolds: [HouseHold] = []
        
        start()
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            houseHolds.removeAll()
            
            
            for houseHold in snapshot.children{
                
                
                for user in snapshot.childSnapshotForPath((houseHold.key) as String!).childSnapshotForPath("users").children {
                    
                    
                    if(self.autID! == (user.value as String)) {
                        
                        if(user.key as String! == "created") {
                            
                            
                            houseHolds.append(HouseHold(household: houseHold.childSnapshotForPath("name").value as! String, key: (houseHold.key) as String!))
                        }else {
                            
                            houseHolds.append(HouseHold(household: houseHold.childSnapshotForPath("sharename").value as! String, key: (houseHold.key) as String!))
                        }
                        for item in snapshot.childSnapshotForPath((houseHold.key) as String!).childSnapshotForPath("items").children {
                            
                            let name = item.key as String!
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

    
    func shareHouseHoldWhitEmail(eMail: String ,houseHoldkey: String) {
        var shareComplited: Bool = false
        let ref = root
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            for user in snapshot.childSnapshotForPath("users").children {
                
                if(eMail == user.childSnapshotForPath("email").value as! String && shareComplited == false) {
                    
                    for houseHoldShareName in snapshot.childSnapshotForPath("houseHolds").childSnapshotForPath(houseHoldkey).children {
                        
                        if(houseHoldShareName.key == "sharename") {
                        
                            let shareName = houseHoldShareName.value as String!
                            ref.childByAppendingPath("users").childByAppendingPath((user.key) as String!).childByAppendingPath("invites").childByAutoId().setValue(["key": houseHoldkey, "name": shareName])
                        }
                        
                    }
                    
                    shareComplited = true
                }
            }
            
        })
        
    }
    
    func removeItemFromHouseHold(houseHoldkey: String, itemName: String) {
        let ref = root.childByAppendingPath("houseHolds").childByAppendingPath(houseHoldkey).childByAppendingPath("items")
        ref.childByAppendingPath(itemName).removeValue()
    }
    
    func removeHouseHoldFromUser(houseHoldkey: String) {
        let ref = root.childByAppendingPath("houseHolds").childByAppendingPath(houseHoldkey).childByAppendingPath("users")
        var removedComplited: Bool = false
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            for i in snapshot.children {
                if(self.autID! == (i.value as String) && removedComplited == false) {
                    ref.childByAppendingPath(i.key as String!).removeValue()
                    removedComplited =  true
                    
                }
            }
        })
    }
    
    
    func addHousHold(name: String){
        var addHouseHoldComlited: Bool = false
       
        root.childByAppendingPath("houseHolds").childByAutoId().setValue(["name": ""])
        
        root.observeEventType(.Value, withBlock: { snapshot in
            
            for house in snapshot.childSnapshotForPath("houseHolds").children {
                
                if(house.childSnapshotForPath("name").value as? String == "" && addHouseHoldComlited == false) {
                
                
                    for userEmail in snapshot.childSnapshotForPath("users").childSnapshotForPath(self.autID).children {
                        let email = userEmail.value! as String
                        self.root.childByAppendingPath("houseHolds").childByAppendingPath((house.key) as String!).childByAppendingPath("users").setValue(["created": self.autID!])
                        self.root.childByAppendingPath("houseHolds").childByAppendingPath((house.key) as String!).updateChildValues(["name": name, "key": (house.key) as String!,  "sharename": "\(email)_\(name)"])
                
                    
                    
                    
                        addHouseHoldComlited = true
                    
                    }
                }
            }
            
        })
    }
    
    func addItemToHouseHould(houseHoldkey: String, itemType: String, index: Int, limit: Int) {
        let item: HouseHoldItem = HouseHoldItem.init(name: itemType, inventory: index, inventoryLimit: limit)
        root.childByAppendingPath("houseHolds").childByAppendingPath(houseHoldkey).childByAppendingPath("items").childByAppendingPath(itemType).setValue(item.toAnyObject())
        
    }
    
    func updateItemIndex(houseHold: String, itemName: String, newIndex: Int) {
        
        var updatedComplited: Bool = false
        let ref = root.childByAppendingPath("houseHolds").childByAppendingPath(houseHold).childByAppendingPath("items")
    
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            for item in snapshot.children {
                
                let name = item.key as String!
                
                if(name == itemName && updatedComplited == false) {
            
                    
                    ref.childByAppendingPath(item.key as String!).childByAppendingPath("antal").setValue(newIndex)
                    updatedComplited = true
                }
                
            }
        
        })

        
    }
    
}
