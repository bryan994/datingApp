//
//  FindFriendsViewController.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import UIKit
import SDWebImage
import Koloda


class FindPartnerViewController: UIViewController,KolodaViewDelegate, KolodaViewDataSource  {
    
    @IBOutlet weak var kolodaView: KolodaView!
    var listOfUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        DataService.userRef.observeEventType(.ChildAdded, withBlock: { userSnapshot in
            DataService.userRef.child(userSnapshot.key).observeEventType(.Value, withBlock: {userSnapshot2 in
                if let user = User(snapshot: userSnapshot2){
                    if user.uid != User.currentUserUid(){
                        self.listOfUser.append(user)
                        self.kolodaView.reloadData()
                    }
                    
                }
            })
        })
    }
    
    @IBAction func left(sender: AnyObject) {
        kolodaView?.swipe(SwipeResultDirection.Left)
        
    }
    
    @IBAction func right(sender: AnyObject) {
        kolodaView?.swipe(SwipeResultDirection.Right)
        
    }

    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(self.listOfUser.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let header = NSBundle.mainBundle().loadNibNamed("MatchPartnerView", owner: 0, options: nil)[0] as? MatchPartner
        let user = self.listOfUser[Int(index)]
        
        if let username = user.username{
            header?.nameLabel.text = username
        }
        
        if let userImageUrl = user.profileImage{
            
            let url = NSURL(string: userImageUrl)
            
            header!.partnerImage!.sd_setImageWithURL(url)
            header!.partnerImage!.clipsToBounds = true
        }
        
        
        return header!
        
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        //Example: loading more cards
        
        let user = self.listOfUser[Int(index)]
        
        if direction.hashValue == 0{
            print("left")
            
            DataService.userRef.child(User.currentUserUid()!).child("dislike").updateChildValues([user.uid!: true])
            
        }else if direction.hashValue == 1{
            print("right")
            
            DataService.userRef.child(User.currentUserUid()!).child("like").updateChildValues([user.uid!: true])
        }
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
}
