//
//  DetailsController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/21/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import Social
import Firebase
import PassKit

protocol giveQRCode {
    func getQRCode(qrCode: CIImage)
}

class DetailsController: UIViewController,PKPaymentAuthorizationViewControllerDelegate {
    
    var qrDelegate : giveQRCode?
    var event : EventObject? = nil
    var qrCodeImage : CIImage!
    var user_id = Auth.auth().currentUser?.uid
    var currentUser = Auth.auth().currentUser
    var eventRefURL = "https://ticker-final-project.firebaseio.com/Events/"
    var userRefURL = "https://ticker-final-project.firebaseio.com/Events/"
    var userPoints = 0
    var userTweeted = 0
    var userShared = 0
    var userEvents = [""]
    var ref = Database.database().reference()
    var membershipType = ""
    var tickets = 0
    var tweeted = 0
    var shared = 0
    var isTweeting = false
    var isSharing = false
    let merchantId = "merchant.com.fullsail.Ticker-FinalProject"
    var eventToPass : EventObject?
    
    
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var alertLabe: UILabel!
    @IBOutlet weak var description_view: UITextView!
    @IBOutlet weak var venue_label: UILabel!
    @IBOutlet weak var eventName_label: UILabel!
    @IBOutlet weak var background_iv: UIImageView!
    @IBOutlet weak var redeem_button: UIButton!
    @IBOutlet weak var showTicket_button: UIButton!
    
    @IBOutlet weak var twitter_button: UIButton!
    @IBOutlet weak var facebook_button: UIButton!
    @IBOutlet weak var applePayButton: UIButton!
    
    
    
    /////////////Apple Pay/////////////////
    var paymentRequest : PKPaymentRequest!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventToPass = event!
        alertLabe.alpha = 0
        ///////SETUP View
        eventName_label.text = event?.name
        if let name = event?.venue_name{
            venue_label.text = "@\(name)"
        }else{
            venue_label.text = "To be anounced"
        }
        description_view.text = event?.event_description
        if let image = event?.photo{
            let data = NSData(contentsOf: URL(string: image)!)
            background_iv.image = UIImage(data: data! as Data)
            //            background_iv.image = UIImage(named: "arcticMonkeys")
        }else{
            background_iv.image = UIImage(named: "party")
        }
        
        DispatchQueue.main.async {
            
            self.loadDtabase(eventURL: self.eventRefURL, userURL: self.userRefURL)
            
            
        }
        
        print(event!.event_type)
        
        if event?.isGoing == true{
            redeem_button.isHidden = true
            showTicket_button.isHidden = false
        }
        
        
        //Do any additional setup after loading the view.
        loadMembership()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareWithFB(image: URL, url: URL, title:String, description:String){
        
        // Create an object
        let properties: [AnyHashable: Any] = ["og:type": "article", "og:title": title, "og:description": description, "og:image": image, "og:url" : url]
        let object = FBSDKShareOpenGraphObject(properties: properties)
        // Create an action
        let action = FBSDKShareOpenGraphAction()
        action.actionType = "news.publishes"
        action.setObject(object, forKey: "article")
        
        let content = FBSDKShareOpenGraphContent()
        content.action = action
        content.previewPropertyName = "article"
        //fb_sahreBUtton.shareContent = content
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_TicketDetails"{
            let sVC = segue.destination as! TicketViewController
            sVC.qrCodeImage = createTicket()
            sVC.event = self.event
            print("HITTING SEGUE")
        }
        
        if segue.identifier == "to_eventDetails"{
            
            let sVC = segue.destination as! EventDetailsController
            sVC.event = self.event
        }
        
        
        
    }
    
    @IBAction func redeemTicket(_ sender: Any) {
        
        if userPoints >= Int((event?.pointsTo_redeem)!)! && tickets > 0{
            
            if let points = event?.pointsTo_redeem{
                
                let alert = UIAlertController(title: "Ticker!", message: "Do you accept to spend \(points) points to redeem this ticket?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    // perhaps use action.title here
                    self.redeem_button.isHidden = true
                    self.showTicket_button.isHidden = false
                    self.tickets -= 1
                    self.userPoints -= Int((self.event?.pointsTo_redeem)!)!
                    let updateEvent = ["free_tickets":String(self.tickets)]
                    let updateUser = ["points": String(self.userPoints)]
                    
                    self.ref.child("Events").child((self.event?.event_id!)!).updateChildValues(updateEvent)
                    self.ref.child("Users").child(self.user_id!).updateChildValues(updateUser)
                    
                    let venueDictionary = ["venue_address":self.event?.venueDictionary["venue_address"] as? String,
                                           "venue_domain": self.event?.venueDictionary["venue_domain"] as? String,
                                           "venue_name": self.event?.venue_name,
                                           "venue_phone": self.event?.venueDictionary["venue_phone"] as? String,
                                           "venue_type": self.event?.venueDictionary["venue_type"] as? String
                                            ]
                    
                    let eventDictionary : [String:Any] =
                        [
                            "date": self.event?.date ?? "error from details date",
                            "event_cost": self.event?.event_cost ?? "error from details cost",
                            "event_description": self.event?.event_description ?? "error from details description",
                            "event_hour": self.event?.event_hour ?? "hour",
                            "event_id": self.event?.event_id ?? "error from details id",
                            "event_type": self.event?.event_type ?? "error from details type",
                            "name": self.event?.name ?? "error from details name",
                            "photo": self.event?.photo ?? "error from details photo",
                            "promoter": self.event?.promoter ?? "error from details promoter",
                            "venue_name": self.event?.venue_name ?? "error from details venue_name",
                            "Venue": venueDictionary
                    ]
                    self.ref.child("Users").child(self.user_id!).child("Events").child((self.event?.event_id!)!).setValue(eventDictionary)
                    
                    
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                print("create code")
                
                
            }
        }else if tickets <= 0{
            
            let alert = UIAlertController(title: "Tickr!", message: "There are no more available tickets for this event.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            let alert = UIAlertController(title: "Tickr!", message: "You don't have enough points to redeem", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func createTicket()-> CIImage{
        let data = "\(event?.name ?? "no name"), \(event?.date ?? "no date")".data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        self.qrCodeImage = filter?.outputImage
        
        qrDelegate?.getQRCode(qrCode: self.qrCodeImage)
        
        return self.qrCodeImage
        
    }
    
    @IBAction func seeTicket(_ sender: Any){
        
        performSegue(withIdentifier: "to_TicketDetails", sender: self)
    }
    
    @IBAction func share(_ sender: Any) {
        userHasFacebook()
        
    }
    
    @IBAction func tweet(_ sender: Any) {
        
        userHasTwitter()
        
    }
    
    @IBAction func applePayAction(_sender: Any){
        
        let payNetworks  = [PKPaymentNetwork.amex, .visa, .masterCard ]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: payNetworks){
            paymentRequest = PKPaymentRequest()
            paymentRequest.countryCode = "US"
            paymentRequest.currencyCode = "USD"
            paymentRequest.merchantIdentifier = merchantId
            paymentRequest.supportedNetworks = payNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.requiredBillingAddressFields = [.all]
            paymentRequest.paymentSummaryItems = self.membershipToSell()
            
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC.delegate = self
            self.present(applePayVC, animated: true, completion: nil)
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


extension DetailsController{
    
    /////Logistic to gamification
    func membershipType(membership: String){
        if membership.lowercased() == "regular" && event?.event_type.lowercased() == "premium"{
            shareLabel.text = "Members Only!"
            applePayButton.isHidden = false
            redeem_button.isHidden = true
            showTicket_button.isHidden = true
            twitter_button.isHidden = true
            facebook_button.isHidden = true
        }
        if membership.lowercased() == "premium" && event?.event_type.lowercased() == "premium"{
            shareLabel.text = "Share to win a ticket!"
            applePayButton.isHidden = true
            redeem_button.isHidden = false
            facebook_button.isHidden = false
            twitter_button.isHidden = false
            //self.playAsPremium(tweeted: self.isTweeting, shared: self.isSharing)
            
            
        }
    }
    
    func playAsPremium(tweeted: Bool, shared: Bool){
        
        if tweeted && shared{
            redeem_button.isHidden = false
        }
        
    }
    
    
    ///// Apple Payment Delegate Protocol
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        
        completion(PKPaymentAuthorizationStatus.success)
        print("User bought item")
        
        let makeHimMember : [String: Any] = ["member":"premium"]
        Database.database().reference().child("Users").child(user_id!).updateChildValues(makeHimMember)
        applePayButton.isHidden = true
        membershipType(membership: "premium")
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func membershipToSell()->[PKPaymentSummaryItem]{
        let membership =  PKPaymentSummaryItem(label: "PREMIUM Membership", amount: 25.00)
        let totalPrice = PKPaymentSummaryItem(label: "TICKR Co.", amount: 25.00, type: .final)
        
        return[membership, totalPrice]
        
    }
    
    
    func userHasTwitter(){
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetController:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetController.setInitialText(event?.name)
            tweetController.add(background_iv.image)
            
            tweetController.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.cancelled:
                    print("Cancelled")
                    
                    
                    break
                case SLComposeViewControllerResult.done:
                    print("Succeeded")
                    
                    self.userPoints += 25
                    self.userTweeted += 1
                    print(self.userPoints)
                    let updateValues = ["points":String(self.userPoints), "tweeted":String(self.userTweeted)]
                    self.ref.child("Users").child(self.user_id!).updateChildValues(updateValues)
                    self.animateAlert()
                    
                    //Update times tweeted
                    self.tweeted += 1
                    let updateSocialSharing = ["tweeted": String(self.tweeted)]
                    self.ref.child("Events").child((self.event?.event_id)!).updateChildValues(updateSocialSharing)
                    self.ref.child("Promotors").child((self.event?.promoterId)!).child("Events").child((self.event?.event_id)!).updateChildValues(updateSocialSharing)
                    self.isTweeting = true
                    
                    
                    break
                    
                }
            }
            
            
            self.present(tweetController, animated: true, completion: nil)
        }else{
            presentController(social:"Twitter", scheme: "TWITTER", action: "tweet")
        }
        
    }
    
    func userHasFacebook(){
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            
            let shareController:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            shareController.setInitialText(event?.name)
            shareController.add(background_iv.image)
            
            shareController.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.cancelled:
                    print("Cancelled")
                    break
                    
                    
                case SLComposeViewControllerResult.done:
                    print("Done")
                    
                    self.userPoints += 25
                    print(self.userPoints)
                    self.userShared += 1
                    let updateValues = ["points":String(self.userPoints), "shared": String(self.userShared)]
                    self.ref.child("Users").child(self.user_id!).updateChildValues(updateValues)
                    self.animateAlert()
                    
                    //Update times shared
                    self.shared += 1
                    let updateSocialSharing = ["shared": String(self.shared)]
                    self.ref.child("Events").child((self.event?.event_id)!).updateChildValues(updateSocialSharing)
                    self.ref.child("Promotors").child((self.event?.promoterId)!).child("Events").child((self.event?.event_id)!).updateChildValues(updateSocialSharing)
                    self.isSharing = true
                    break
                }
            }
            
            
            self.present(shareController, animated: true, completion: nil)
        }else{
            presentController(social:"Facebook", scheme: "FACEBOOK", action: "share")
        }
        
        
    }
    
    func presentSuccessController(){
        let alert = UIAlertController(title: "Tickr", message: "You just earned 25 points!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentController(social:String, scheme: String, action: String){
        
        let alert = UIAlertController(title: "Credentials", message: "Please login to a \(social) account to \(action).", preferredStyle: UIAlertControllerStyle.alert)
        
        let twitterAction = UIAlertAction(title: "Go to settings", style: .default) { (UIAlertAction) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"App-Prefs:root=\(scheme)")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(twitterAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadDtabase(eventURL: String, userURL: String){
        
        //load event
        Database.database().reference().child("Events").child((event?.event_id)!).observe(.value, with: { (data) in
            
            if let dictionary = data.value as? [String: AnyObject]{
                if let tickets = dictionary["free_tickets"] as? String, let shared = dictionary["shared"] as? String, let tweeted = dictionary["tweeted"] as? String{
                    self.tickets = Int(tickets)!
                    self.shared = Int(shared)!
                    self.tweeted = Int(tweeted)!
                    print("times shared \(self.shared)")
                    print("times tweeted \(self.tweeted)")
                    print(tickets)
                }
            }else{
                print("Not loading event info")
            }
        })
        
        
        ///Load user
        
        Database.database().reference().child("Users").child(user_id!).observe(.value, with: { (userSnap) in
            //print(userSnap)
            if let dictionary = userSnap.value as? [String:AnyObject]{
                if let points = dictionary["points"] as? String, let tweeted = dictionary["tweeted"] as? String, let shared = dictionary["shared"] as? String{
                    print("my points are \(points)")
                    self.userPoints = Int(points)!
                    self.userTweeted = Int(tweeted)!
                    self.userShared = Int(shared)!
                    
                    if let events = dictionary["Events"] as? NSDictionary{
                        
                        for e in events{
                            self.userEvents.append(e.key as! String)
                            for ue in self.userEvents{
                                if ue == self.event?.event_id!{
                                    self.redeem_button.isHidden = true
                                    self.showTicket_button.isHidden = false
                                    
                                }
                            }
                        }
                    }else{
                        print("There are no events yet with this user")
                    }
                    
                }else{
                    print("not reading points")
                }
            }
        })
        
        print("MMEBMME \(self.membershipType)")
        
        
        
    }
    
    func loadMembership(){
        Database.database().reference().child("Users").child(user_id!).observeSingleEvent(of: .value, with: { (snap) in
            if let dictionary = snap.value as? [String: AnyObject]{
                if let membership = dictionary["member"] as? String{
                    self.membershipType = membership
                    print("USER IS A MEMBERSHIP TYPE: \(self.membershipType)")
                    self.membershipType(membership: self.membershipType)
                }
            }
        })
    }
    
    
    func animateAlert(){
        UIView.animate(withDuration: 1, animations: {
            self.alertLabe.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 2, animations: {
                self.alertLabe.alpha = 2
            }, completion: { (true) in
                UIView.animate(withDuration: 2, animations: {
                    self.alertLabe.alpha = 0
                }, completion: nil)
            })
        }
    }
    
    
}


