//
//  SpliTableTableViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/5/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class SpliTableTableViewController: UITableViewController {
    
    var fireEvents = [EventObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvents()
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fireEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellPromoterCell
        
       // cell.textLabel?.text = fireEvents[indexPath.row].name
        cell.configureCell(event: self.fireEvents[indexPath.row])

        // Configure the cell...

        return cell
    }
    
    @IBAction func addEventAction(_ sender: Any) {
        performSegue(withIdentifier: "toCreateEvent", sender: self)
    }
    
    @IBAction func logOut(_ sender: Any) {
        
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetails") {
            var detail: SplitDetailViewController
            if let navigationController = segue.destination as? UINavigationController {
                detail = navigationController.topViewController as! SplitDetailViewController
            } else {
                detail = segue.destination as! SplitDetailViewController
            }
            
            if let path = tableView.indexPathForSelectedRow?.row {
                detail.event = self.fireEvents[path]
            }
        }
        
        
        
        
    }
    

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

extension SpliTableTableViewController{
    func fetchEvents(){
        Database.database().reference().child("Events").observe(.childAdded, with: { (data) in
            if let dictionary = data.value as? [String:AnyObject]{
                let event = EventObject()
                if let cost = dictionary["event_cost"] as? String, let date = dictionary["date"] as? String , let e_description = dictionary["event_description"] as? String, let e_hour = dictionary["event_hour"] as? String, let e_type = dictionary["event_type"] as? String, let name =  dictionary["name"] as? String, let photo = dictionary["photo"] as? String, let promoter = dictionary ["promoter"] as? String, let v_name = dictionary["venue_name"] as? String, let event_id = dictionary["event_id"] as? String, let redeem = dictionary["redeem"] as? String, let tickets = dictionary["free_tickets"] as?String, let vDictionary = dictionary["Venue"] as? [String: AnyObject], let tweeted = dictionary["tweeted"] as? String, let shared = dictionary["shared"] as? String, let interested = dictionary["interested"] as? String{
                    
                    event.date = date
                    event.event_cost = cost
                    event.event_description = e_description
                    event.event_hour = e_hour
                    event.event_id = event_id
                    event.event_type = e_type
                    event.freeTickets = tickets
                    event.name = name
                    event.photo = photo
                    event.promoter = promoter
                    event.venue_name = v_name
                    event.tweeted = tweeted
                    event.shared = shared
                    event.interested = interested
                    event.pointsTo_redeem = redeem
                    event.venueDictionary = vDictionary
                    
                    self.fireEvents.append(event)
                    for e in self.fireEvents{
                        let pastDate = e.date
                        let format = "EEE, MMM d, yyyy"
                        let currentDate = Date().toString(format: format)
                        if(currentDate?.toDate(format: format))! > (pastDate?.toDate(format: format)!)!{
                            
                            self.fireEvents = self.fireEvents.filter{$0 != e}
                            
                        }
                    }
                    
                    
                }else{
                    print("SOMETHING BAD IN BINDING SPLIT TABLE")
                }
                
                
                    self.tableView.reloadData()
                
            }
        })
    }
}
