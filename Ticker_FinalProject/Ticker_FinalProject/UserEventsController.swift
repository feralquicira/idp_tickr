//
//  UserEventsController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/10/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class UserEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var userID = Auth.auth().currentUser?.uid
    
    var upcomingEvents = [EventObject]()
    var pastEvents = [EventObject]()
    var segmentNum: Int!
    var data = [[EventObject]] ()
    var newdata = [["hi", " my"], ["name", "is","luis"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        DispatchQueue.main.async {
            self.fetchEvents()
        }
        
        segmentNum = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var retVal = 0
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            retVal = upcomingEvents.count
            break
        default:
            retVal = pastEvents.count
            break
        }
       
        return retVal
    
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEvents_cell", for: indexPath) as! UserCell
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            cell.setUpCell(event: upcomingEvents[indexPath.row])
            break
        default:
            cell.setUpCell(event: pastEvents[indexPath.row])
            break
        }
        
        
        
        return cell
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        segmentNum = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    
    
    
    func fetchEvents(){
        Database.database().reference().child("Users").child((userID)!).child("Events").observe(.childAdded, with: { (data) in
            if let dictionary = data.value as? [String: AnyObject]{
                
                let event = EventObject()
                
                if let eName = dictionary["name"] as? String, let date = dictionary["date"] as? String, let promoter = dictionary["promoter"] as? String, let photo = dictionary["photo"] as? String, let venue = dictionary["venue_name"] as? String{
                    
                    event.name = eName
                    event.date = date
                    event.promoter = promoter
                    event.photo = photo
                    event.venue_name = venue
                    
                    
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
    

   
}
