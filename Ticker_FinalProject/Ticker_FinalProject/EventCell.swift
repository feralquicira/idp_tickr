//
//  EventCell.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/21/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var event_image: UIImageView!
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_date: UILabel!
    @IBOutlet weak var cardView: UIView!
   
    func setUpCell(event:Event){
        
        let data = NSData(contentsOf: event.event_image! as URL)
        
        if data != nil{
        
        self.event_image.image = UIImage(data: data! as Data)
        }else{
            self.event_image.image = UIImage(named: "fer")
        }
        self.event_name.text = event.event_name
        self.event_date.text = "\(event.event_date) | 12:00pm | \(event.event_venue)"
        
        cardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha:1.0)
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = ((UIColor.black).withAlphaComponent(0.2).cgColor)
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        
        
    }
    
    /*let data = NSData(contentsOf: url! as URL)
     userImage_iv.image = UIImage(data: data! as Data)*/
}
