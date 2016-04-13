//
//  FirebaseService.swift
//  fbOne
//
//  Created by Aaron saunders on 4/4/16.
//  Copyright © 2016 Aaron Saunders. All rights reserved.
//
// http://www.christopheresplin.com/post/124334674865/firebase-data-structures
//

import Foundation
import Firebase

class FirebaseService: NSObject {
    
    static let sharedInstance = FirebaseService()
    
    static var BASE_URL = "https://[YOUR-APP-NAME].firebaseio.com/"

    let baseRef:Firebase
    
    var messageItemsRef:AnyObject!
    
    var authData:FAuthData!
    
    // array of message information
    var messageItems = [[String:String]]()
    
    //
    var authHandle:UInt!
    
    override init() {
        Firebase.setLoggingEnabled(true)
        self.baseRef = Firebase(url: FirebaseService.BASE_URL)
    }
    
    //
    // MARK: Authentication
    //
    func setupAuth(authenticatedCallback: ((FAuthData!) -> Void)!) {
        authHandle = baseRef.observeAuthEventWithBlock { (authData) -> Void in
            
            if authData != nil {
                authenticatedCallback(authData)
            }
            
            self.authData = authData
            
        }
    }
    
    func doLogout() {
        print("in logout")
        baseRef.unauth()
    }
    
    func doCreateUser(email:String, password:String, authenticatedCallback: ((FAuthData!) -> Void)!)  {
        
        baseRef.createUser(email, password: password) { (error: NSError!) in
            
            if error == nil {
                
                // Create a child path with a key set to the uid underneath the "users" node
                // This creates a URL path like the following:
                //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                self.baseRef.childByAppendingPath("users")
                    .childByAppendingPath(self.authData.uid)
                    .setValue(["provider": self.authData.provider,"displayName": email], withCompletionBlock: { (error, auth) -> Void in
                        if (error == nil) {
                            self.doLogin(email, password: password, authenticatedCallback: authenticatedCallback)
                        }
                    })
            } else {
                print("ERROR CREATING USER")
            }
        }
    }
    
    
    // 
    // login a user
    // https://www.firebase.com/docs/ios/guide/user-auth.html#section-login
    //
    func doLogin(email:String, password:String, authenticatedCallback: ((FAuthData!) -> Void)!)  {
        let cb = authenticatedCallback
        
        baseRef.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
            
            self.authData = authData
            
            cb(authData)
            
        })
    }
    
    // insert messages with autoid
    // retieve messages
    // merge query
    // access authenticated user from service
    
    func setupMessages( isPrivate: Bool, callback: (() -> Void)!) {
        
        messageItemsRef = self.baseRef
        
        messageItemsRef = self.baseRef
            .childByAppendingPath("userObjects")
            .childByAppendingPath(isPrivate ? "private-messages" :"public-messages")
            .childByAppendingPath(self.authData.uid)
        
        print("messageItemsRef: \(messageItemsRef)")
        
        messageItemsRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our message data.
            
            self.messageItems.removeAll();
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // pull the data from the dictionary and ser variables
                    let text = snap.value["text"]  as! String
                    let date = snap.value["date"] as! String
                    let id = snap.key
                    
                    
                    // insert data into the array
                    self.messageItems.insert([
                        "text": text,
                        "date": date,
                        "id" : id], atIndex: 0)
                    
                }
                
                // this is the function to call when we are done updating
                // local information based on the firebase call
                callback()
            }
            
        })
    }
    
    // returns the array of message items
    func getMessageItems () -> [[String:String]] {
        return messageItems
    }
    
    
    func removeMessageItemObserver() {
        messageItemsRef.removeAllObservers()
    }
    
    func saveMessage(message:[String:String], isPrivate:Bool) {
        
        messageItemsRef = self.baseRef
            .childByAppendingPath("userObjects")
            .childByAppendingPath(isPrivate ? "private-messages" :"public-messages")
            .childByAppendingPath(self.authData.uid)
        
        let date = "\(NSDate().timeIntervalSince1970 * 1000)"
        messageItemsRef.childByAutoId()
            .setValue(["text" : message["text"] as String! , "date": date], withCompletionBlock: {(error,fb)  in
                if (error != nil) {
                    print(error)
                }
            })
    }
    
}