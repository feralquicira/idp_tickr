//
//  UpcomingEventsController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/14/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class UpcomingEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var uTableView: UITableView!
    
    
    var userID = Auth.auth().currentUser?.uid
    
    var upcomingEvents = [EventObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uTableView.delegate = self
        uTableView.dataSource = self

        DispatchQueue.main.async {
            print("Loading fetch")
            self.fetchEvents()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return upcomingEvents.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEvents_cell", for: indexPath) as! UserCell
        
        cell.setUpCell(event: upcomingEvents[indexPath.row])
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchEvents(){
        Database.database().reference().child("Users").child((userID)!).child("Events").observe(.childAdded, with: { (data) in
            if let dictionary = data.value as? [String: AnyObject]{
                
                let event = EventObject()
                
                if let eName = dictionary["name"] as? String, let date = dictionary["date"] as? String, let promoter = dictionary["promoter"] as? String, let photo = dictionary["photo"] as? String{
                    
                    event.name = eName
                    event.date = date
                    event.promoter = promoter
                    event.photo = photo
                    
                    self.upcomingEvents.append(event)
                    for e in self.upcomingEvents{
                        let pastDate = e.date
                        let format = "EE, MMM d, yyyy"
                        let currentDate = Date().toString(format: format)
                        
                        if (currentDate?.toDate(format: format))! > (pastDate?.toDate(format: format)!)!{
                            print("upcoming event \(e.name)")
                            
                            self.upcomingEvents = self.upcomingEvents.filter{$0 != e}
                        }
                        
                        
                    }
                    
                    
                }
                DispatchQueue.main.async {
                    self.uTableView.reloadData()
                }
                
            }else{
                print("my events is wrong")
            }
        })
    }

}
