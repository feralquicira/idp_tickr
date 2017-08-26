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
    
    
    
    
    var event = Event.init(event_cost: "60", event_date: "Fri, Aug 29, 2017", event_description: "\"Arctic Monkeys are a guitar rock band from Sheffield, England. The group, which is comprised of frontman and lyricist Alex Turner, guitarist Jamie Cook, drummer Matt Helders and bassist Nick O’Malley, are one of the most successful British bands of the 21st century: their debut album ‘Whatever People Say I Am, That’s What I’m Not’ is the fastest-selling debut in British chart history and they have released five consecutive Number One albums. They have released two albums, ‘Whatever…’ and their most recent LP ‘AM’, which have received 10/10 reviews from NME. Other accolades and achievements include winning seven Brit Awards and headlining Glastonbury Festival on two occasions.\" ", event_time: "9:00pm", event_type: "Premium", event_name: "Arctic Monkeys", event_image: NSURL(string: "https://i.ytimg.com/vi/bpOSxM0rNPM/hqdefault.jpg")!, event_venue: "Hard Rock Hotel")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        evenName_label.text = event.event_name
        eventDate_label.text = event.event_date
        eventCost_label.text = "$\(event.event_cost)"
        eventType_label.text = event.event_type
        venueName_label.text = event.event_venue
        eventTIme_label.text = event.event_time
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
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
