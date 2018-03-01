//
//  DetailsSheetController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/22/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class DetailsSheetController: UIViewController {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName_label: UILabel!
    @IBOutlet weak var eventDate_label: UILabel!
    @IBOutlet weak var eventCost_label: UILabel!
    @IBOutlet weak var eventType_label: UILabel!
    @IBOutlet weak var venueName_label: UILabel!
    @IBOutlet weak var venueAddress_label: UILabel!
    @IBOutlet weak var venuePhone_label: UILabel!
    @IBOutlet weak var venueDomain_label: UILabel!
    @IBOutlet weak var venueType_label: UILabel!
    var event = EventObject()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageEvent = event.photo{
            self.eventImage.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
        }else{
            eventImage.image = UIImage(named: "party")
        }
        
        if let name = event.name, let date = event.date,  let venue = event.venue_name, let type = event.event_type, let cost = event.event_cost{
            
            eventName_label.text = name
            eventDate_label.text = date
            eventCost_label.text = "$\(String(describing: Double(cost)!))"
            eventType_label.text = type
            venueName_label.text = venue
            venueAddress_label.text = self.event.venueDictionary["venue_address"] as? String
            venuePhone_label.text = self.event.venueDictionary["venue_phone"] as? String
            venueDomain_label.text = self.event.venueDictionary["venue_domain"] as? String
            venueType_label.text = self.event.venueDictionary["venue_type"] as? String
            
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneActione(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
