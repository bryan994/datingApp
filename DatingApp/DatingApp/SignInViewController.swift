//
//  SignInViewController.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard)))
        
    }
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    
    @IBAction func signInOnButtonPressed(sender: AnyObject) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let user = user {
                
                User.signIn(user.uid)
                
                self.performSegueWithIdentifier("ProfileSegue", sender: nil)
                
            }else {
                let controller = UIAlertController(title: "Registration Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                
                controller.addAction(dismissButton)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
        }
    }
    
    
    
}
