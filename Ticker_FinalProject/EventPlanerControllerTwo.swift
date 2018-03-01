//
//  EventPlanerControllerTwo.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/28/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class EventPlanerControllerTwo: UIViewController {
    
    
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var descriptionTextfield: UITextView!
    @IBOutlet weak var ticketCost_textfield: UITextField!
    @IBOutlet weak var freeTickets_textfield: UITextField!
    @IBOutlet weak var points_label: UILabel!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var premiumSwitch: UISwitch!
    @IBOutlet weak var generalSwitch: UISwitch!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editingButton: UIButton!
    var acindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    
    var eventEditing : EventObject!
    
    
    
    var preDictionary : [String: AnyObject]? = [:]
    var navTitle = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title_label.text = preDictionary?["name"] as? String
        //print(preDictionary["name"]!)
       ticketCost_textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setUI()
        
        keepEditingEvent(event: eventEditing)
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Event Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        print("is editing")
        if let points = ticketCost_textfield.text, !points.isEmpty{
        points_label.text = String(Int(Float(points)! * Float(2).rounded()))
        }else{
            points_label.text = "points to redeem"
            
        }
        
    }
    
    @IBAction func finidhEditingAction(_ sender: Any) {
        acindicator.center = self.view.center
        acindicator.hidesWhenStopped = true
        acindicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(acindicator)
        self.acindicator.startAnimating()
        postEdit()
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        let dRef = Database.database().reference()
        
        if let event = eventEditing{
        
        DispatchQueue.main.async {
            dRef.child("Events").child(event.event_id).removeValue()
            dRef.child("Promotors").child((Auth.auth().currentUser?.uid)!).child("Events").child(event.event_id).removeValue()
            
            self.performSegue(withIdentifier: "totab", sender: self)
        }
            
        }
        
    }
    
    
    func keepEditingEvent(event: EventObject?){
        if let eventEdit = event{
            deleteButton.isHidden = false
            editingButton.isHidden = false
            postButton.isHidden = true
            title_label.text = eventEdit.name
            descriptionTextfield.text = eventEdit.event_description
            ticketCost_textfield.text = eventEdit.event_cost
            freeTickets_textfield.text = eventEdit.freeTickets
            
            if let points = ticketCost_textfield.text, !points.isEmpty{
                points_label.text = String(Int(Float(points)! * Float(2).rounded()))
            }else{
                points_label.text = "points to redeem"
                
            }
            
            if eventEdit.event_type.lowercased() == "premium"{
                premiumSwitch.isOn = true
                generalSwitch.isOn = false
            }else{
                
                premiumSwitch.isOn = false
                generalSwitch.isOn = true
            }
        }else{
            deleteButton.isHidden = true
            editingButton.isHidden = true
            postButton.isHidden = false
        }
    }
    
    @IBAction func postEvent(_ sender: Any) {
        if premiumSwitch.isOn && generalSwitch.isOn{
            
            presentAlertWithCancel(message: "You can only choose one type of event.", button_title: "OK")
            
        }else{
        acindicator.center = self.view.center
        acindicator.hidesWhenStopped = true
        acindicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(acindicator)
        self.acindicator.startAnimating()
        
        post()
        }
        
    }
    
    func postEdit(){
        UIApplication.shared.beginIgnoringInteractionEvents()
        
            let imageName = NSUUID().uuidString
            let postID = eventEditing.event_id
            let dRef = Database.database().reference()
            _ = Auth.auth().currentUser?.uid
            let storeRef = Storage.storage().reference().child("\(imageName).jpg")
            
            if let desc = descriptionTextfield.text, !desc.isEmpty, let t_cost = ticketCost_textfield.text, !t_cost.isEmpty, let freeTicket = freeTickets_textfield.text, !freeTicket.isEmpty{
                preDictionary?["event_description"] = desc as AnyObject
                preDictionary?["event_cost"] = t_cost as AnyObject
                if premiumSwitch.isOn && generalSwitch.isOn{
                    presentAlertWithCancel(message: "You can only choose one type of event.", button_title: "OK")
                }else{
                    if premiumSwitch.isOn{
                        preDictionary?["event_type"] = "Premium" as AnyObject
                        
                    }else{
                        preDictionary?["event_type"] = "General" as AnyObject
                    }
                }
            }else{
                presentAlertWithCancel(message: "You have to fill al fields.", button_title: "OK")
            }
            
            
            
            if let photo = preDictionary?["photo"]{
                
                storeRef.putData(photo as! Data, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error ?? "hay error")
                        return
                    }else{
                        if let image = metadata?.downloadURL()?.absoluteString{
                            self.preDictionary?["photo"] = image as AnyObject
                            self.preDictionary?["promoter"] = Auth.auth().currentUser?.displayName  as AnyObject
                            self.preDictionary?["event_id"] = postID as AnyObject
                            self.preDictionary?["free_tickets"] = self.eventEditing.freeTickets as AnyObject
                            self.preDictionary?["interested"] = self.eventEditing.interested as AnyObject
                            self.preDictionary?["redeem"] = self.eventEditing.pointsTo_redeem as AnyObject
                            self.preDictionary?["shared"] = self.eventEditing.shared as AnyObject
                            self.preDictionary?["tweeted"] = self.eventEditing.tweeted as AnyObject
                            self.preDictionary?["promoter_id"] = Auth.auth().currentUser?.uid as AnyObject
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                dRef.child("Events").child(self.eventEditing.event_id).setValue(self.preDictionary)
                                dRef.child("Promotors").child((Auth.auth().currentUser?.uid)!).child("Events").child(self.eventEditing.event_id).setValue(self.preDictionary)
                                
                            }
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.performSegue(withIdentifier: "totab", sender: self)
                            
                            
                        }else{
                            print("metadata optional binding")
                        }
                        
                    }
                })
            }else{
                print("photo optional binding")
            }
            
    }
    
    func post(){
        UIApplication.shared.beginIgnoringInteractionEvents()
        let imageName = NSUUID().uuidString
        let postID = NSUUID().uuidString
        let dRef = Database.database().reference()
        _ = Auth.auth().currentUser?.uid
        let storeRef = Storage.storage().reference().child("\(imageName).jpg")
        
        if let desc = descriptionTextfield.text, !desc.isEmpty, let t_cost = ticketCost_textfield.text, !t_cost.isEmpty, let freeTicket = freeTickets_textfield.text, !freeTicket.isEmpty{
            preDictionary?["event_description"] = desc as AnyObject
            preDictionary?["event_cost"] = t_cost as AnyObject
            if premiumSwitch.isOn && generalSwitch.isOn{
                presentAlertWithCancel(message: "You can only choose one type of event.", button_title: "OK")
            }else{
                if premiumSwitch.isOn{
                    preDictionary?["event_type"] = "Premium" as AnyObject
                    
                }else{
                    preDictionary?["event_type"] = "General" as AnyObject
                }
            }
        }else{
            presentAlertWithCancel(message: "You have to fill al fields.", button_title: "OK")
        }
        
        
        
        if let photo = preDictionary?["photo"]{
            
            storeRef.putData(photo as! Data, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error ?? "hay error")
                    return
                }else{
                    if let image = metadata?.downloadURL()?.absoluteString{
                        self.preDictionary?["photo"] = image as AnyObject
                        self.preDictionary?["promoter"] = Auth.auth().currentUser?.displayName  as AnyObject
                        self.preDictionary?["event_id"] = postID as AnyObject
                        self.preDictionary?["free_tickets"] = self.freeTickets_textfield.text! as Any as AnyObject
                        self.preDictionary?["interested"] = "0" as AnyObject
                        self.preDictionary?["redeem"] = String(Int(Float(self.ticketCost_textfield.text!)! * Float(2).rounded())) as AnyObject
                        self.preDictionary?["shared"] = "0" as AnyObject
                        self.preDictionary?["tweeted"] = "0" as AnyObject
                        self.preDictionary?["promoter_id"] = Auth.auth().currentUser?.uid as AnyObject
                        
                        
                        
                        DispatchQueue.main.async {
                            dRef.child("Events").child(postID).setValue(self.preDictionary)
                            dRef.child("Promotors").child((Auth.auth().currentUser?.uid)!).child("Events").child(postID).setValue(self.preDictionary)
                        }
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.performSegue(withIdentifier: "totab", sender: self)
                        
                        
                    }else{
                        print("metadata optional binding")
                    }
                    
                }
            })
        }else{
            print("photo optional binding")
        }
    }
    
    
    func checkEverythingIsCorrect() -> Bool{
        
        return false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    //

}


extension EventPlanerControllerTwo{
    
    func setUI(){
        
        
        
        switchView.layer.borderWidth = 1.0
        switchView.layer.borderColor = UIColor(colorLiteralRed: 44/255, green: 235/255, blue: 204/255, alpha: 1.0).cgColor
        switchView.layer.cornerRadius = 5.0
        
        descriptionTextfield.layer.borderWidth = 1.0
        descriptionTextfield.layer.borderColor = UIColor(colorLiteralRed: 44/255, green: 235/255, blue: 204/255, alpha: 1.0).cgColor
        descriptionTextfield.layer.cornerRadius = 5.0
        
    }
    
    func presentAlertWithCancel(message: String, button_title: String){
        
        let alert = UIAlertController(title: "Ticker", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button_title, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
