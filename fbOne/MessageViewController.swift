//
//  MessageViewController.swift
//
//  fbOne2
//
//  Created by Aaron Saunders on 4/1/16.
//  Copyright © 2016 Aaron Saunders. All rights reserved.
//

import UIKit
import Firebase

//
// MARK: Setting Up the View
class MessageViewController: UITableViewController {
    
    var firebaseService = FirebaseService.sharedInstance
    var showPrivateData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        firebaseService.setupAuth { (authData) -> Void in
            self.firebaseService.setupMessages(self.showPrivateData)  { () -> Void in
            print("showing private data: \(self.showPrivateData)")
                
                self.tableView.reloadData()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        firebaseService.removeMessageItemObserver()
    }
    
    //
    // toggle between the private and the public data
    //
    @IBAction func doToggleView(sender: UIBarButtonItem) {
        showPrivateData = !showPrivateData
        
        self.firebaseService.setupMessages(showPrivateData)  { () -> Void in
            print("showing private data: \(self.showPrivateData)")
            
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func doAddItem(sender: UIBarButtonItem) {
        // get title for the image
        var alert = UIAlertController(title: "Enter Title For Image", message: "", preferredStyle:
            UIAlertControllerStyle.Alert)
        
        
        func configurationMessageText(textField: UITextField!) {
            textField.placeholder = "some message text..."
        }
        
        alert.addTextFieldWithConfigurationHandler(configurationMessageText)
        
        func configurationPrivateFlag(textField: UITextField!) {
            textField.placeholder = "Private Message (true|false)"
        }
        
        alert.addTextFieldWithConfigurationHandler(configurationPrivateFlag)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            let textTitle = (alert.textFields![0] as UITextField).text
            let textPrivate = (alert.textFields![1] as UITextField).text
            
            self.firebaseService.saveMessage(["text" : textTitle!], isPrivate: textPrivate == "true")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:nil))
        
        self.presentViewController(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @IBAction func doLogout(sender: AnyObject) {
        //firebaseService.doLogout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        firebaseService.doLogout()
    }
}

//
// MARK: TableView Section
extension MessageViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseService.getMessageItems().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = firebaseService.getMessageItems()[indexPath.row]
        
        // We are using a custom cell.
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell") as? MessageTableViewCell {
            
            // Send the single joke to configureCell() in MessageTableViewCell.
            cell.configureCell(message)
            
            return cell
            
        } else {
            return MessageTableViewCell()
        }
        
    }
    
    
    
    
    
    
}


