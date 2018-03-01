//
//  UserCell.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/10/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var eventName_label: UILabel!
    @IBOutlet weak var eventDate_label: UILabel!
    @IBOutlet weak var promoter_button: UIButton!

    func setUpCell(event:EventObject){
        
        if let imageEvent = event.photo{
            self.eventImage.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
        }
        
        if let eName = event.name, let date = event.date, let promoter = event.promoter{
            self.eventName_label.text = eName
            self.eventDate_label.text = date
            
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: promoter, attributes: underlineAttribute)
            
            self.promoter_button.setAttributedTitle(underlineAttributedString, for: .normal)
        }
        
        cardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 70/255, alpha:1.0)
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = ((UIColor.black).withAlphaComponent(0.2).cgColor)
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        
    }

}
