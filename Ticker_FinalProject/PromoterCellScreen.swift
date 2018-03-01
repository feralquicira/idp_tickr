//
//  PromoterCellScreen.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/29/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

protocol customEditProtocol {
    
    func editEventWithID(eventToPassID: EventObject)
    
}

class PromoterCellScreen: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var editBUtton: UIButton!
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    var eventToPass : EventObject!
    var delegate : customEditProtocol!
    
    @IBAction func editAction(_ sender: Any){
        if let e = eventToPass{
        print("tapping event: \(e.freeTickets!)")
        }
        
        if delegate != nil{
            self.delegate.editEventWithID(eventToPassID: eventToPass)
        }
    }
    
    
    
    func cellConfig(event: EventObject){
        eventToPass = event
        if let imageEvent = event.photo{
            self.eventImage.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
        }
        if let eName = event.name, let date = event.date, let hour = event.event_hour, let venue = event.venue_name, let type = event.event_type{
            self.eventNameLabel.text = eName
            self.eventDateLabel.text = "\(date) | \(hour) | \(venue)"
            self.eventTypeLabel.text = type
            if type == "Premium"{
                print("This is a premium event")
                
                let size = self.eventTypeLabel.font.pointSize
                self.eventTypeLabel.font = UIFont(name: "Verdana-BoldItalic", size: size)
            }else{
                print("This is general event")
                let size = self.eventTypeLabel.font.pointSize
                self.eventTypeLabel.font = UIFont(name: "FuturaPT-Book", size: size)
            }
        }
        
        
        cardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 70/255, alpha:1.0)
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = ((UIColor.black).withAlphaComponent(0.2).cgColor)
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
