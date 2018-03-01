//
//  SplitDetailViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/5/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class SplitDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventName_label: UILabel!
    @IBOutlet weak var venueName_label: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var interested_label: UILabel!
    @IBOutlet weak var tweeted_label: UILabel!
    @IBOutlet weak var shared_label: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    
    
    var event = EventObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (event.event_id) != nil{
            moreButton.isHidden = false
        }else{
            moreButton.isHidden = true
        }
        
        // Do any additional setup after loading the view.
        setUI(event: event)
        socialListener()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreAction(_ sender: Any) {
        
        performSegue(withIdentifier: "toSheetController", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSheetController"{
            let sVC = segue.destination as! DetailsSheetController
            sVC.event = self.event
        }
    }
    
    
    func socialListener(){
        if let eID = event.event_id{
            
            Database.database().reference().child("Events").child(eID).observe(.value, with: { (data) in
                if let dictionary = data.value as? [String: AnyObject]{
                    if let interested = dictionary["interested"] as? String, let shared = dictionary["shared"] as? String, let tweeted = dictionary["tweeted"] as? String{
                        self.interested_label.text = "Interested: \n\(interested)"
                        self.shared_label.text = "Times shared: \n\(shared)"
                        self.tweeted_label.text = "Times tweeted: \n\(tweeted)"
                    }
                }
            })
            
        }
        
        
        
        
    }
    
    func setUI(event: EventObject){
        if let imageEvent = event.photo{
            self.backgroundImage.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
        }
        if let eName = event.name, let vName = event.venue_name, let desc = event.event_description{
            
            eventName_label.text = eName
            venueName_label.text = "@\(vName)"
            descriptionView.text = desc
            
        }else{
            eventName_label.text = ""
            venueName_label.text = ""
            descriptionView.text = ""
            interested_label.text = ""
            shared_label.text = ""
            tweeted_label.text = ""
        }
        
        
        
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


