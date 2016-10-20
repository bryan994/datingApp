//
//  User.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import Foundation
import FirebaseDatabase


class User{
    
    var uid: String?
    var email: String?
    var username: String?
    var profileImage: String?
    var gender: String?
    
    init?(snapshot: FIRDataSnapshot){
        
        self.uid = snapshot.key

        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }

        if let dictEmail = dict["email"] as? String{
            self.email = dictEmail
        }else{
            self.email = ""
        }
        if let dictUsername = dict["username"] as? String{
            self.username = dictUsername
        }else{
            self.username = ""
        }
        if let dictProfile = dict["profileImage"] as? String{
            self.profileImage = dictProfile
        }else{
            self.profileImage = ""
        }
        if let dictGender = dict["gender"] as? String{
            self.gender = dictGender
        }else{
            self.gender = ""
        }
    }

class func signIn (uid: String){
    //storing the uid of the person in the phone's default settings.
    NSUserDefaults.standardUserDefaults().setValue(uid, forKeyPath: "uid")
    
}

class func isSignedIn() -> Bool {
    
    if let _ = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
        return true
    }else {
        return false
    }
    
}

class func currentUserUid() -> String? {
    return NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
}

}
