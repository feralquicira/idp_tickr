//
//  PromoterDetailsViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class PromoterDetailsViewController: UIViewController, CellListener {
    
    @IBOutlet weak var eventName_label: UILabel!
    @IBOutlet weak var venueName_label: UILabel!
    @IBOutlet weak var evenDescription_label: UITextView!
    
    var event : EventPromoter?
    
     static var event_name = ""
    
     static var event_description = ""
     static var event_venue = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        print("Local \(PromoterDetailsViewController.event_name)")
        print(event?.event_name ?? "No NAME")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passEvent(event: EventPromoter) {
        self.event = event
        self.eventName_label.text = event.event_name
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
