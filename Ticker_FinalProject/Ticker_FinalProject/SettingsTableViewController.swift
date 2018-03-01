//
//  SettingsTableViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/22/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var tweetedLabel: UILabel!
    @IBOutlet weak var attendedLabel: UILabel!
    var eventsAttended = [EventObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStats(userUIID: Auth.auth())
        if let attended = loadEvents(user: Auth.auth()){
            attendedLabel.text = String(attended)
        }else{
            attendedLabel.text = "0"
        }
        
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"App-Prefs:root=FACEBOOK")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }else{
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"App-Prefs:root=TWITTER")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            break
        case 1:
            
            break
            
        default:
            
            DispatchQueue.main.async {
                
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                print("sign out from FACEBOOK")
                
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
    
    func loadStats(userUIID: Auth){
        if let id = userUIID.currentUser?.uid{
        Database.database().reference().child("Users").child(id).observe(.value, with: { (data) in
            if let dictionary = data.value as? [String: AnyObject]{
                if let tweeted = dictionary["tweeted"] as? String, let shared = dictionary["shared"] as? String{
                    self.tweetedLabel.text = tweeted
                    self.sharedLabel.text = shared
                    
                }
            }
        })
        }
    }
    
    func loadEvents(user: Auth) -> Int?{
        if let id = user.currentUser?.uid{
            Database.database().reference().child("Users").child(id).child("Events").observe(.childAdded, with: { (data) in
                if let dictionary = data.value as? [String: AnyObject]{
                    let e = EventObject()
                    if let eID = dictionary["event_id"] as? String{
                        e.event_id = eID
                        self.eventsAttended.append(e)
                        
                        //self.attendedLabel.text = String(self.eventsAttended.count)
                        
                    }
                }
            })
        }
        
        return self.eventsAttended.count
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
