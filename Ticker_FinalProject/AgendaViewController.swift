//
//  AgendaViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/21/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AgendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var userPoints_label: UILabel!
    @IBOutlet weak var userImage_iv: UIImageView!
    @IBOutlet weak var tableView: UITableView!
  
    
    var events : [Event] = [Event.init(event_cost: "60", event_date: "Fri, Aug 29, 2017", event_description: "\"Arctic Monkeys are a guitar rock band from Sheffield, England. The group, which is comprised of frontman and lyricist Alex Turner, guitarist Jamie Cook, drummer Matt Helders and bassist Nick O’Malley, are one of the most successful British bands of the 21st century: their debut album ‘Whatever People Say I Am, That’s What I’m Not’ is the fastest-selling debut in British chart history and they have released five consecutive Number One albums. They have released two albums, ‘Whatever…’ and their most recent LP ‘AM’, which have received 10/10 reviews from NME. Other accolades and achievements include winning seven Brit Awards and headlining Glastonbury Festival on two occasions.\" ", event_time: "9:00pm", event_type: "Premium", event_name: "Arctic Monkeys", event_image: NSURL(string: "https://i.ytimg.com/vi/bpOSxM0rNPM/hqdefault.jpg")!, event_venue: "Hard Rock Hotel")
                            
                            
//                            
//                            Event.init(event_cost: "60", event_date: "Fri, Aug 29, 2017", event_description: "\"Arctic Monkeys are a guitar rock band from Sheffield, England. The group, which is comprised of frontman and lyricist Alex Turner, guitarist Jamie Cook, drummer Matt Helders and bassist Nick O’Malley, are one of the most successful British bands of the 21st century: their debut album ‘Whatever People Say I Am, That’s What I’m Not’ is the fastest-selling debut in British chart history and they have released five consecutive Number One albums. They have released two albums, ‘Whatever…’ and their most recent LP ‘AM’, which have received 10/10 reviews from NME. Other accolades and achievements include winning seven Brit Awards and headlining Glastonbury Festival on two occasions.\" ", event_time: "9:00pm", event_type: "Premium", event_name: "Arctic Monkeys", event_image: NSURL(string: "https://i.ytimg.com/vi/bpOSxM0rNPM/hqdefault.jpg")!, event_venue: "Hard Rock Hotel")
    ]
    var firebaseEvents : [Event]? = []
    var ev : Event?
    
    
    
    var userName = ""
    var url : NSURL? = nil
    
    /*DATABASE SETUP*/
    var databaseRef = DatabaseReference()
    var databaseHandle = DatabaseHandle()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*DATABSE SETUP*/
        databaseRef = Database.database().reference()
        //readEvents()
        ////////////////
        
        username_label.text = userName
        let data = NSData(contentsOf: url! as URL)
        userImage_iv.image = UIImage(data: data! as Data)

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.firebaseEvents?.count
        print("iteeeems are \(rows!)")
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agenda_cell" , for: indexPath) as! EventCell
        
        for event in self.events{
        
        cell.setUpCell(event: event)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rox = indexPath.row
        print(events[rox])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    

    
    
    
    
    
    //////////////
    //lougout
    
    @IBAction func logout(_ sender: Any) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.performSegue(withIdentifier: "id_toMain", sender: self)
    }
    
    func readEvents(){
        databaseHandle = databaseRef.child("Events").observe(.childAdded, with: { (snapshot) in
            //Code to execute when data is added
            //Take the value from snapshot and add to array of events
            for events in snapshot.children.allObjects as! [DataSnapshot]{
                print("\(events)")
                

//                let d = snapshot.value as? [String: AnyObject] ?? [:]
//                
//                let event_name = d["name"]
//                let event_photo = d["photo"]
//                let event_cost = d["cost"]
//                let event_date = d["date"]
//                let event_desc = d["description"]
//                let event_type = d["event_type"]
//                let venue_name = d["venue_name"]
//                let event_hour = d["event_hour"]
                
                
                
//                self.ev = Event(event_cost: event_cost as! Int, event_date: event_date as! String, event_description: event_desc as! String, event_time: event_hour as! String, event_type: event_type as! String, event_name: event_name as! String, event_image: NSURL(string: event_photo as! String), event_venue: venue_name as! String)
//                
//                
                
            }
            
            //self.firebaseEvents?.append(self.ev!)
            
            
            
        })
        self.tableView.reloadData()
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "id_toDetails"{
            let sVC = segue.destination as! DetailsController
            let index  = self.tableView.indexPathForSelectedRow?.row
            sVC.event = self.events[0]
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
