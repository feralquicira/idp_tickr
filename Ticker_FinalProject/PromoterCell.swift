//
//  PromoterCell.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class PromoterCell: UITableViewCell {
    
    
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_date: UILabel!
    @IBOutlet weak var promoter: UILabel!
    @IBOutlet weak var event_image: UIImageView!
    
    @IBOutlet weak var eventType_label: UILabel!

    func setUpCell(event:EventObject){
        
        
        
        if let imageEvent = event.photo{
            self.event_image.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
        }
        
        if let name = event.name, let date = event.date, let hour = event.event_hour, let venue = event.venue_name, let type = event.event_type{
        self.event_name.text = name
        self.event_date.text = "\(date) | \(hour) | \(venue)"
            
            self.promoter.text = event.promoter
            self.eventType_label.text = type
            if type == "Premium"{
                print("This is a premium event")
                let size = self.eventType_label.font.pointSize
                self.eventType_label.font = UIFont(name: "Verdana-BoldItalic", size: size)
            }else{
                print("This is general event")
                let size = self.eventType_label.font.pointSize
                self.eventType_label.font = UIFont(name: "FuturaPT-Book", size: size)
            }
            
        }else{
            print("hay pedo")
        }
        
        
    }


}
