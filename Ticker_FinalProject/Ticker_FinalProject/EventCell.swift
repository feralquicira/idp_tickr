//
//  EventCell.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/21/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

protocol customSegueProtocol {
    func callSegueFromButton(eventToPassID: String)
}

class EventCell: UITableViewCell {
    
    @IBOutlet weak var event_image: UIImageView!
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_date: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var event_type: UILabel!
    @IBOutlet weak var goingLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var promoterButton: UIButton!
    
    var promotertoPass : String!
    var vdelegate : customSegueProtocol!
    
    @IBAction func promoterAction(_ sender: Any) {
        print("tapping promoter: \(promotertoPass)")
        
        if vdelegate != nil{
            self.vdelegate.callSegueFromButton(eventToPassID: promotertoPass)
        }
    }
    
    
    
    
    
    func setUpCell(event:EventObject){
        
       
       promotertoPass = event.promoterId
        
        print("promoter to pass is \(promotertoPass) and his name is \(event.promoter)")
        
        if (event.isGoing) != nil{
            goingLabel.isHidden = false
        }else{
            goingLabel.isHidden = true
        }
        
        if let imageEvent = event.photo{
            self.event_image.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
        }
        
        
        if let name = event.name, let date = event.date, let hour = event.event_hour, let venue = event.venue_name, let type = event.event_type, let points = event.pointsTo_redeem, let promoter = event.promoter{
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: promoter, attributes: underlineAttribute)
            
            self.event_name.text = name
            self.promoterButton.setAttributedTitle(underlineAttributedString, for: .normal)
            self.promoterButton.tintColor = UIColor(colorLiteralRed: 44/255, green: 232/245, blue: 204/255, alpha: 1.0)
            self.pointsLabel.text = "\(points) points to redeem!"
            self.event_date.text = "\(date) | \(hour) | \(venue)"
            
            self.event_type.text = type
            if type == "Premium"{
                print("This is a premium event")
                
                let size = self.event_type.font.pointSize
                self.event_type.font = UIFont(name: "Verdana-BoldItalic", size: size)
            }else{
                print("This is general event")
                let size = self.event_type.font.pointSize
                self.event_type.font = UIFont(name: "FuturaPT-Book", size: size)
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
    
    /*let data = NSData(contentsOf: url! as URL)
     userImage_iv.image = UIImage(data: data! as Data)*/
}
