//
//  PromoterEventsScreen.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/29/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class PromoterEventsScreen: UIViewController,  UITableViewDelegate, UITableViewDataSource, customEditProtocol {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var userID = Auth.auth().currentUser?.uid
    
    var upcomingEvents = [EventObject]()
    var pastEvents = [EventObject]()
    var data = [[EventObject]] ()
    var segmentNum: Int!
    var eventToPass : EventObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.main.async {
            self.fetchEvents()
        }
        
               // Do any additional setup after loading the view.
        
        segmentNum = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var retVal = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            retVal = upcomingEvents.count
            break
        default:
            retVal = pastEvents.count
            break
        }
        
        return retVal
        
        
        
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        segmentNum = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    func editEventWithID(eventToPassID: EventObject) {
        
        self.eventToPass = eventToPassID
        self.performSegue(withIdentifier: "toEditEvent", sender: eventToPassID)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditEvent"{
           
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! EventPlaneerControllerOne
            svc.eventPassed = self.eventToPass
            
            
        }
    }




//Configure Cell

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "pCell", for: indexPath) as! PromoterCellScreen
    
    switch segmentedControl.selectedSegmentIndex {
    case 0:
        cell.cellConfig(event: upcomingEvents[indexPath.row])
        cell.editBUtton.isHidden = false
        cell.delegate = self
        
        break
    default:
        cell.cellConfig(event: pastEvents[indexPath.row])
        cell.editBUtton.isHidden = true
        break
    }
    
    
    
    
    
    return cell
}

func fetchEvents(){
    Database.database().reference().child("Promotors").child((userID)!).child("Events").observe(.childAdded, with: { (data) in
        if let dictionary = data.value as? [String: AnyObject]{
            
            let event = EventObject()
            
            if let eName = dictionary["name"] as? String, let date = dictionary["date"] as? String, let promoter = dictionary["promoter"] as? String, let photo = dictionary["photo"] as? String, let venue = dictionary["venue_name"] as? String, let hour = dictionary["event_hour"] as? String, let type = dictionary["event_type"] as? String, let id = dictionary["event_id"]as? String, let cost = dictionary["event_cost"] as? String, let e_description = dictionary["event_description"] as? String, let e_hour = dictionary["event_hour"] as? String,  let tickets = dictionary["free_tickets"] as?String, let vDictionary = dictionary["Venue"] as? [String: AnyObject], let redeem = dictionary["redeem"] as? String, let tweeted = dictionary["tweeted"] as? String, let shared = dictionary["shared"] as? String, let interested = dictionary["interested"] as? String{
                
                event.name = eName
                event.date = date
                event.promoter = promoter
                event.photo = photo
                event.venue_name = venue
                event.event_hour = hour
                event.event_type = type
                event.event_id = id
                event.event_description = e_description
                event.event_hour = e_hour
                event.event_cost = cost
                event.freeTickets = tickets
                event.venueDictionary = vDictionary
                event.pointsTo_redeem = redeem
                event.tweeted = tweeted
                event.shared = shared
                event.interested = interested
                
                
                
                
                
                self.upcomingEvents.append(event)
                self.pastEvents.append(event)
                for e in self.upcomingEvents{
                    let pastDate = e.date
                    let format = "EE, MMM d, yyyy"
                    let currentDate = Date().toString(format: format)
                    
                    if (currentDate?.toDate(format: format))! > (pastDate?.toDate(format: format)!)!{
                        print("upcoming event \(e.name)")
                        
                        self.upcomingEvents = self.upcomingEvents.filter{$0 != e}
                        self.data.append(self.upcomingEvents)
                    }else{
                        
                        for _ in self.pastEvents{
                            let cDate = Date().toString(format: format)
                            self.pastEvents = self.pastEvents.filter{$0.date.toDate(format: format)! < (cDate?.toDate(format: format))! }
                            self.data.append(self.pastEvents)
                            print(self.pastEvents.count)
                        }
                    }
                    
                    
                    
                }
                
                
            }
            
            self.tableView.reloadData()
        }
    })
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
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
 
 */

}
