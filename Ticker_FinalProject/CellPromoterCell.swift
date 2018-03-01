//
//  CellPromoterCell.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/28/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class CellPromoterCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(event: EventObject){
        let format = "EEE, MMM d, yyyy"
        let datee = event.date.toDate(format: format)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM \nd"
        
        
        dateLabel.text = dateFormatter.string(from: datee!)
        eventNameLabel.text = event.name
        venueNameLabel.text = "@\(event.venue_name!)"
        
        
        //set cardview
        cellView.layer.borderWidth = 1.0
        cellView.layer.borderColor = UIColor(colorLiteralRed: 44/255, green: 232/245, blue: 204/255, alpha: 1.0).cgColor
        cellView.layer.cornerRadius = 3.0
        cellView.layer.masksToBounds = false
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected")
        // Configure the view for the selected state
    }

}
