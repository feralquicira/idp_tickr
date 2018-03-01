//
//  PromoterSettingsTableViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 11/22/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class PromoterSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var eventsCreatedLabel: UILabel!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var tweetedLabel: UILabel!
    
    
    
   
    var eventsToPost : Int!
    var eventsCreated = [EventObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let us = Auth.auth().currentUser?.uid
        print("current user is: \(String(describing: us)) ")
        
        loadEvents(user: Auth.auth())
        
        //loadStats(userUIID: Auth.auth())
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.section {
        case 0:
            //do nothing
            break
        default:
            DispatchQueue.main.async {
                
                
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    print("sign out from firebase")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                self.performSegue(withIdentifier: "id_toMain", sender: self)
                
            }
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func loadStats(userUIID: Auth){
//        if let id = userUIID.currentUser?.uid{
//            Database.database().reference().child("Promotors").child(id).child("Events").observe(.value, with: { (data) in
//                if let dictionary = data.value as? [String: AnyObject]{
//                    if let tweeted = dictionary["tweeted"] as? String, let shared = dictionary["shared"] as? String{
//                        print("tweeted total \(tweeted)")
//                        
//                    }
//                }
//            })
//        }
//    }
    
    func loadEvents(user: Auth) {
        
        
        if let userId = user.currentUser?.uid{
            Database.database().reference().child("Promotors").child(userId).child("Events").observe(.childAdded, with: { (snap) in
                print(snap)
                if let dictionary = snap.value as? [String:AnyObject]{
                    let e = EventObject()
                    var interested = 0
                    var shared = 0
                    var tweeted = 0
                    if let event_id = dictionary["event_id"] as? String, let inter = dictionary["interested"] as? String, let sharing = dictionary["shared"] as? String, let tweeting = dictionary["tweeted"] as? String{
                        e.event_id = event_id
                        e.interested = inter
                        e.shared = sharing
                        e.tweeted = tweeting
                        self.eventsCreated.append(e)
                        print("counting events: \(self.eventsCreated.count)")
                        self.eventsToPost =  self.eventsCreated.count
                        print("the events to post are: \(self.eventsToPost)")
                        self.eventsCreatedLabel.text = String(self.eventsToPost)
                        
                        for ev in self.eventsCreated{
                            interested +=  Int(ev.interested)!
                            shared +=  Int(ev.shared)!
                            tweeted +=  Int(ev.tweeted)!
                        }
                        
                        self.interestedLabel.text = String(interested)
                        self.sharedLabel.text = String(shared)
                        self.tweetedLabel.text = String(tweeted)
                        
                    }
                    
                    
                }
                
            })
            
            
        }
    
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
