//
//  Event.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/21/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import Foundation
import UIKit

class Event{
    var event_cost = ""
    var event_date = ""
    var event_description = ""
    var event_time = ""
    var event_type = ""
    var event_name = ""
    var event_image : NSURL? = nil
    var event_venue = ""
    
    
    
    init(event_cost:String, event_date: String, event_description: String, event_time: String, event_type: String, event_name: String, event_image: NSURL, event_venue: String) {
        self.event_cost = event_cost
        self.event_date = event_date
        self.event_description = event_description
        self.event_time = event_time
        self.event_type = event_type
        self.event_name = event_name
        self.event_image = event_image
        self.event_venue = event_venue
    }
    
    
}
