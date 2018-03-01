//
//  PromoterProfileDetails.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/18/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class PromoterProfileDetails: UIViewController {
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var promoterName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followers_label: UILabel!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var events_label: UILabel!
    @IBOutlet weak var biographyVeiw: UITextView!
    
    
    
    var eventsList = [EventObject]()
    var promoterID : String!
    var promoter = PromoterObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchPromoter(promoter: promoter)
        fetchEvents(promoter: promoter)
        
        setUI(view: profilePicImage)
        setUI(view: followersView)
        setUI(view: eventsView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        profilePicImage.layer.cornerRadius = profilePicImage.frame.height / 2.0
        
        followersView.layer.cornerRadius = followersView.frame.height / 2.0
        
        eventsView.layer.cornerRadius = eventsView.frame.height / 2.0
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followAction(_ sender: Any) {
    }
    
    func setUI(view: UIView){
        
        view.layer.borderWidth = 2
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
        
        
    }
    
    func fetchPromoter(promoter: PromoterObject){
        Database.database().reference().child("Promotors").child(promoterID).observe(.value, with: { (data) in
            if let dictionary = data.value as? [String: AnyObject]{
                if let biography = dictionary["biography"] as? String,
                    let promoterName = dictionary["company_name"] as? String,
                let profilePic = dictionary["profilePicture"] as? String{
                    self.promoterName.text = promoterName
                    self.biographyVeiw.text = biography
                    self.profilePicImage.loadImageUsingCacheWithPhotoURL(string_url: profilePic)
                    self.navigationItem.title = promoterName
                }
            }
        })
    }
    
    func fetchEvents(promoter: PromoterObject){
        Database.database().reference().child("Promotors").child(promoterID).child("Events").observe(.childAdded, with: { (data) in
            let pevent = EventObject()
            if let dictionary = data.value as? [String: AnyObject]{
                if let eventID = dictionary["event_id"] as? String{
                    pevent.event_id = eventID
                    self.eventsList.append(pevent)
                    self.events_label.text = "Events\n\(self.eventsList.count)"
                    print(self.eventsList.count)
                }
            }
        })
        
        
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
