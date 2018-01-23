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
    
    func getUserEmail(start: () -> (), completion: (String)-> Void) {
        var userEmail: String!
        start()
            users.childByAppendingPath(autID).childByAppendingPath("email").observeEventType(.Value, withBlock: { snapshot in
                
                userEmail = snapshot.value as! String
                
                completion(userEmail)
            })
        
    }
    
    func logoutUser() {
    
        
        
    }
    
    func deleteInvite(houseHoldKey: String) {
        let ref = root.childByAppendingPath("users").childByAppendingPath(self.autID!).childByAppendingPath("invites")
        var removedComplited: Bool = false
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            for i in snapshot.children {
                if(houseHoldKey == (i.childSnapshotForPath("key").value as! String) && removedComplited == false) {
                    ref.childByAppendingPath(i.key as String!).removeValue()
                    
                    removedComplited =  true
                    
                }
                
            }
        })

    
    }
    
    func acceptInvite(houseHoldKey: String) {
        
        let ref = root.childByAppendingPath("houseHolds")
        ref.childByAppendingPath(houseHoldKey).childByAppendingPath("users").childByAutoId().setValue(autID)
        deleteInvite(houseHoldKey)
    }
    
    func getInviteHouseholds(start: () -> (), completion: ([Invite])-> Void){
        
        let ref = root.childByAppendingPath("users").childByAppendingPath(self.autID!)
        var invites: [Invite] = []
        
        start()
        
        ref.childByAppendingPath("invites").observeEventType(.Value, withBlock: { snapshot in
            invites.removeAll()
            
            for invite in snapshot.children {
                
                let inviteFrom = invite.childSnapshotForPath("name").value as! String
                let key =  invite.childSnapshotForPath("key").value as! String
                invites.append(Invite(inviteFrom: inviteFrom, key: key))
                
            }

            
            completion(invites)
        })
        
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
    
    
    func checkUserInvitesAndHouseHolds(eMail: String ,houseHoldkey: String, start: () -> (), completion: (Bool)-> Void) {
        var checkComplited: Bool = false
        var inviteOrHouseHoldFound: Bool = false
        var inviteUserKey: String!
            start()
        
        root.observeEventType(.Value, withBlock: { snapshot in
            if(checkComplited == false) {
                    for user in snapshot.childSnapshotForPath("users").children {
                    
                        if(eMail == user.childSnapshotForPath("email").value as! String) {
                        
                            inviteUserKey = user.key
                        }
                    
                    }
                if(inviteUserKey != nil) {
                    
                    for invite in snapshot.childSnapshotForPath("users").childSnapshotForPath((inviteUserKey) as String!).childSnapshotForPath("invites").children {
                        
                            if(houseHoldkey == invite.childSnapshotForPath("key").value as! String) {
                                inviteOrHouseHoldFound = true
                            }
                        
                        }
                        
                        for house in snapshot.childSnapshotForPath("houseHolds").childSnapshotForPath((houseHoldkey) as String!).childSnapshotForPath("users").children {
                    
                            if(house.value == inviteUserKey) {
                                inviteOrHouseHoldFound = true
                            }
                        }
                }
                        completion(inviteOrHouseHoldFound)
                        checkComplited = true
                
            }
        })
    
    }
    
    func shareHouseHoldWhitEmail(eMail: String, userInloggdEmail: String ,houseHoldkey: String,houseHold: String, start: () -> (), completion: (Bool)-> Void){
        var foundUser: Bool = false
        var shareComplited: Bool = false
        let ref = root.childByAppendingPath("users")
        
        
            start()
        
            ref.observeEventType(.Value, withBlock: { snapshot in
            if(shareComplited == false) {
            
                for user in snapshot.children {
                
                    if(eMail == user.childSnapshotForPath("email").value as! String) {
                    
                                        
                            let splitEmail = userInloggdEmail.componentsSeparatedByString("@")
                            let shareName = "\(houseHold) @ \(splitEmail[0])"
                            let splitshareName = shareName.componentsSeparatedByString("@")
                            let inviteName = "\(splitshareName[0]) @ \(splitshareName[1])"
                            ref.childByAppendingPath((user.key) as String!).childByAppendingPath("invites").childByAutoId().setValue(["key": houseHoldkey, "name": inviteName])
                        
                        foundUser = true
                        
                    }
                
                }
                
                completion(foundUser)
                shareComplited = true
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
                
                
                    
                        let email = snapshot.childSnapshotForPath("users").childSnapshotForPath(self.autID).childSnapshotForPath("email").value as! String
                        let splitEmail = email.componentsSeparatedByString("@")
                    
                        self.root.childByAppendingPath("houseHolds").childByAppendingPath((house.key) as String!).childByAppendingPath("users").setValue(["created": self.autID!])
                        self.root.childByAppendingPath("houseHolds").childByAppendingPath((house.key) as String!).updateChildValues(["name": name, "key": (house.key) as String!,  "sharename": "\(name) @ \(splitEmail[0])"])
                
                        addHouseHoldComlited = true
                    
                    }
                }
            
        })
    }
    
    func addItemToHouseHould(houseHoldkey: String, itemType: String, index: Int, limit: Int) {
        if(houseHoldkey != "nil") {
            let item: HouseHoldItem = HouseHoldItem.init(name: itemType, inventory: index, inventoryLimit: limit)
            root.childByAppendingPath("houseHolds").childByAppendingPath(houseHoldkey).childByAppendingPath("items").childByAppendingPath(itemType).setValue(item.toAnyObject())
        }
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
