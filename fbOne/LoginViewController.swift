//
//  LoginViewController.swift
//  fbOne
//
//  Created by Aaron saunders on 4/5/16.
//  Copyright © 2016 Aaron Saunders. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    var firebaseService = FirebaseService.sharedInstance

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        firebaseService.setupAuth { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier("ToMainTabController", sender: nil)
            }
            
        }
    }
    
    @IBAction func unwindForLoginPage(storyboard:UIStoryboardSegue) {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doLoginAction(sender: AnyObject) {
        firebaseService.doLogin(emailTextField.text!, password: passwordTextField.text!, authenticatedCallback: { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier("ToMainTabController", sender: nil)
            }
            
        })
    }


    @IBAction func doCreateAccountAction(sender: AnyObject) {
                
        firebaseService.doCreateUser(emailTextField.text!, password: passwordTextField.text!, authenticatedCallback: { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier("ToMainTabController", sender: nil)
            }
            
        })
        
    }


}
