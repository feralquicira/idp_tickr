//
//  EventDetailsController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/23/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class EventDetailsController: UIViewController {
    
    @IBOutlet weak var eventDate_label: UILabel!
    @IBOutlet weak var evenName_label: UILabel!
    @IBOutlet weak var eventCost_label: UILabel!
    @IBOutlet weak var eventType_label: UILabel!
    @IBOutlet weak var venueName_label: UILabel!
    @IBOutlet weak var eventTIme_label: UILabel!
    @IBOutlet weak var venuePhone_label: UILabel!
    @IBOutlet weak var venuePage_label: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var venueAddess_label: UILabel!
    
    
    
    var event : EventObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = event?.photo{
            let data = NSData(contentsOf: URL(string: image)!)
            backgroundImage.image = UIImage(data: data! as Data)
            //            background_iv.image = UIImage(named: "arcticMonkeys")
        }else{
            backgroundImage.image = UIImage(named: "arcticMonkeys")
        }
        
        if let e = event{
            print("there is an object")
            evenName_label.text = e.name
            eventDate_label.text = e.date
            eventCost_label.text = "$\(String(describing: Double(e.event_cost!)!))"
            eventType_label.text = e.event_type
            if e.event_type == "Premium"{
                let size = self.eventType_label.font.pointSize
                self.eventType_label.font = UIFont(name: "Verdana-BoldItalic", size: size)
            }else{
                let size = self.eventType_label.font.pointSize
                self.eventType_label.font = UIFont(name: "FuturaPT-Book", size: size)
            }
            venueName_label.text = e.venue_name
            
            venuePhone_label.text = e.venueDictionary["venue_phone"] as? String
            venuePage_label.text = e.venueDictionary["venue_domain"] as? String
            venueAddess_label.text = e.venueDictionary["venue_address"] as? String
            
        }else{
            print("no event here")
        }
      

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     let string = "123 Main St. / (555) 555-5555"
     let types: NSTextCheckingResult.CheckingType = [.address, .phoneNumber]
     let detector = try? NSDataDetector(types: types.rawValue)
     detector?.enumerateMatches(in: string, range: NSMakeRange(0, string.utf16.count)) {
     (result, _, _) in
     print(result)
     }
    */

}
