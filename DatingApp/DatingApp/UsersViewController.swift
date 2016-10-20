//
//  UsersViewController.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class UsersViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var userProfile: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.borderWidth = 1
        
        guard let currentUserID = self.userProfile else {
            return
        }
        
        DataService.userRef.child(currentUserID).observeSingleEventOfType(.Value, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                self.title = user.username
                self.nameLabel.text = user.username
                if let userImageUrl = user.profileImage{
                    let url = NSURL(string: userImageUrl)
                    self.imageView.sd_setImageWithURL(url)
                }
                
            }
            
        })
    }
    
    @IBAction func signUpOnButtonPressed(sender: AnyObject) {
        
        try! FIRAuth.auth()?.signOut()
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userUID")
        
        
        goBackToLogin()
        
    }
    
    func goBackToLogin(){
        let appDelegateTemp = UIApplication.sharedApplication().delegate!
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let LogInViewController = storyboard.instantiateInitialViewController()
        appDelegateTemp.window?!.rootViewController = LogInViewController
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "FriendSegue"{
            let nextScene = segue.destinationViewController as! FindFriendsViewController
            nextScene.userProfile = self.userProfile
        }
    }
    

}
