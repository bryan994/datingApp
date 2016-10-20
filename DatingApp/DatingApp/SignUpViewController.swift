//
//  ViewController.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var gender: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard)))
        
    }
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func genderOnButtonPressed(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
            self.gender = "male"
            
        }else if sender.selectedSegmentIndex == 1{
            self.gender = "female"
        }
    }
    
    @IBAction func signUpOnButtonPressed(sender: AnyObject) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let gender = self.gender else {
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {(user, error)in
            if let user = user {
                
                NSUserDefaults.standardUserDefaults().setObject((user.uid), forKey: "userUID")
                User.signIn(user.uid)

                let userDict = ["email": email, "username":username, "gender": gender]
                DataService.userRef.child(user.uid).setValue(userDict)
                
                self.performSegueWithIdentifier("ProfileSegue", sender: nil)
                
            }else {
                let controller = UIAlertController(title: "Registration Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                
                controller.addAction(dismissButton)
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            }
            
        })
    }
    

}

