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
    

    func setUpCell(event:EventPromoter){
        
        let data = NSData(contentsOf: event.event_image! as URL)
        
        if data != nil{
            
            self.event_image.image = UIImage(data: data! as Data)
        }else{
            self.event_image.image = UIImage(named: "fer")
        }
        self.event_name.text = event.event_name
        self.event_date.text = "\(event.event_date) | 12:00pm | \(event.event_venue)"
        self.promoter.text = event.event_promoter
        
    }


}
