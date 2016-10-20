//
//  UserProfileViewController.swift
//  DatingApp
//
//  Created by Bryan Lee on 20/10/2016.
//  Copyright © 2016 Bryan Lee. All rights reserved.
//

import UIKit
import SDWebImage

class FindFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var listOfUser = [User]()
    var users: String!
    var filteredTableData = [User]()
    var resultSearchController = UISearchController()
    var userProfile: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barTintColor = UIColor.init(red: 0/255, green: 176/255, blue: 255/255, alpha: 1)
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        
        DataService.userRef.observeEventType(.ChildAdded, withBlock: { userSnapshot in
            DataService.userRef.child(userSnapshot.key).observeEventType(.Value, withBlock: {userSnapshot2 in
                if let user = User(snapshot: userSnapshot2){
                    self.listOfUser.append(user)
                    for (index,i) in self.listOfUser.enumerate(){
                        if i.uid == self.userProfile{
                            self.listOfUser.removeAtIndex(index)
                        }
                        self.tableView.reloadData()
                    }
                }
            })
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.listOfUser.count
        }
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListSegue") as! ListTableViewCell
        
        
        if (self.resultSearchController.active){
            let user = filteredTableData[indexPath.row]
        cell.nameLabel.text = user.username
        
        if let userImageUrl = user.profileImage{
            let url = NSURL(string: userImageUrl)
            cell.profileImage.sd_setImageWithURL(url)
        }
        
        return cell
            
        }else{
            let user = listOfUser[indexPath.row]
            cell.nameLabel.text = user.username
            
            if let userImageUrl = user.profileImage{
                let url = NSURL(string: userImageUrl)
                cell.profileImage.sd_setImageWithURL(url)
            }
            
            return cell
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        filteredTableData.removeAll(keepCapacity: false)
        
        
        let array = listOfUser.filter(){
            ($0.gender!.lowercaseString).rangeOfString(searchController.searchBar.text!.lowercaseString) != nil
        }
        filteredTableData = array
        
        self.tableView.reloadData()
        }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.resultSearchController.active){
            let user = filteredTableData[indexPath.row]
            self.userProfile = user.uid
            self.performSegueWithIdentifier("UserSegue", sender: self)
        }else{
            let user = listOfUser[indexPath.row]
            self.userProfile = user.uid
            self.performSegueWithIdentifier("UserSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UserSegue"{
            let nextScene = segue.destinationViewController as! UsersViewController
            nextScene.userProfile = self.userProfile
        }
    }

}
