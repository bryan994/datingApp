//
//  ProfilePageViewController.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Fusuma
import SDWebImage

class ProfilePageViewController: UIViewController, FusumaDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var cameraShown:Bool = false
    var userProfile = User.currentUserUid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.borderWidth = 1
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openFusuma))
        imageView.addGestureRecognizer(tapGesture)
        imageView.userInteractionEnabled = true
        
        guard let currentUserID = User.currentUserUid() else {
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
    
    
    func openFusuma(selectedImage: UIImage) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        self.presentViewController(fusuma, animated: true, completion:nil)
        self.cameraShown = true
    }
    
    
    
    func fusumaImageSelected(image: UIImage) {
        
        self.imageView.image = image
        
        let uniqueImageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("\(uniqueImageName).png")
        
        let selectedImage = UIImageJPEGRepresentation((image), 0.5)!
        storageRef.putData(selectedImage, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                print(error)
                return
            }
            
            if let imageURL = metadata?.downloadURL()?.absoluteString, user = User.currentUserUid(){
                
                SDImageCache.sharedImageCache().storeImage(self.imageView.image, forKey: imageURL)
                DataService.userRef.child(user).updateChildValues(["profileImage":imageURL])
            }
        })

    }

    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        
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
        if segue.identifier == "ProfileSegue"{
            let nextScene = segue.destinationViewController as! FindFriendsViewController
            nextScene.userProfile = self.userProfile
        }
    }
    

}
