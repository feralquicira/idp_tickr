//
//  EventPromoter.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import Foundation
import UIKit

class EventPromoter: Event {
    
    var event_promoter = ""
    
    init(event_cost: String, event_date: String, event_description: String, event_time: String, event_type: String, event_name: String, event_image: NSURL, event_venue: String, event_promoter: String) {
        
        self.event_promoter = event_promoter
        
        super.init(event_cost: event_cost, event_date: event_date, event_description: event_description, event_time: event_time, event_type: event_type, event_name: event_name, event_image: event_image, event_venue: event_venue)
        
    }
    
    
    
    
    
}
