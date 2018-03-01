//
//  EventPlaneerControllerOne.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class EventPlaneerControllerOne: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var event_photoIv: UIImageView!
    
    @IBOutlet weak var eventName_label: UITextField!
    
    @IBOutlet weak var venueName_label: UITextField!
    
    @IBOutlet weak var venueAddress_label: UITextField!
    
    @IBOutlet weak var eventDate_label: UITextField!
    
    @IBOutlet weak var eventTime_label: UITextField!
    
    let imagePicker = UIImagePickerController()
    let pickerView = UIPickerView()
    var myImage : UIImage!
    
    var testString = ""
    
    
    var mainDictionary : [String:AnyObject] = [:]
    var venueDictionary : [String: AnyObject] = [:]
    var eventPassed : EventObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.modalTransitionStyle = .flipHorizontal
        giveGestureToImage()
        
        pickerView.delegate = (self as UIPickerViewDelegate)
        eventDate_label.inputView = pickerView
        
        venueName_label.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
//        eventName_label.text = eventPassed.name
        editEvent(event: eventPassed)
        
        
    }
    
    func editEvent(event: EventObject?){
        if let eventToEdit = event{
            
            eventName_label.text = eventToEdit.name
            venueName_label.text = eventToEdit.venue_name
            venueAddress_label.text = eventToEdit.venueDictionary["venue_address"] as? String
            eventDate_label.text = eventToEdit.date
            eventTime_label.text = eventToEdit.event_hour
            
            venueDictionary = ["venue_name": eventToEdit.venueDictionary["venue_name"] as AnyObject,
                               "venue_type": eventToEdit.venueDictionary["venue_type"] as AnyObject,
                               "venue_address": eventToEdit.venueDictionary["venue_address"] as AnyObject,
                               "venue_phone": eventToEdit.venueDictionary["venue_phone"] as AnyObject,
                               "venue_domain": eventToEdit.venueDictionary["venue_domain"] as AnyObject]
            
       
            
            if let imageEvent = eventToEdit.photo{
                self.event_photoIv.loadImageUsingCacheWithPhotoURL(string_url: imageEvent)
            }
            
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(_ sender:UITextField)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        print("writing")
    }
    
    
    
    @IBAction func selectPicture(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func giveGestureToImage(){
        event_photoIv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (touchPicture)))
        event_photoIv.isUserInteractionEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("\(info)")
        
        if let image  = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            event_photoIv.image = image
            myImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func touchPicture(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_secondForm"{
            
            if let theImage = self.event_photoIv.image{
                
                if let imageLow = UIImageJPEGRepresentation(theImage, 1.0)  {
                    if let date = eventDate_label.text , !date.isEmpty, let time = eventTime_label.text, !time.isEmpty, let vName = venueName_label.text, !vName.isEmpty, let eName = eventName_label.text, !eName.isEmpty{
                        
                        
                        mainDictionary  = ["date":date as AnyObject ,
                                           "venue_name": vName as AnyObject,
                                           "event_hour":time as AnyObject ,
                                           "photo" : imageLow as AnyObject ,
                                           "name" : eName as AnyObject,
                                           "Venue" : venueDictionary as AnyObject
                        ]
                        
                        let sVC = segue.destination as! EventPlanerControllerTwo
                        sVC.preDictionary = mainDictionary
                        sVC.eventEditing = self.eventPassed
                        
                        
                    }else{
                        let alert = UIAlertController(title: "Tickr", message: "Please fill allt he fields", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
                
                else{
                    let alert = UIAlertController(title: "Ticker", message: "Downlod error. PLEASE GO BACK AND WAIT FOR DOWNLOAD", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
            }
                
            
            
            
        }
        
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func timeEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EventPlaneerControllerOne.timePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    
    @IBAction func dateEditing(_ sender: UITextField) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EventPlaneerControllerOne.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func timePickerValueChanged(_ sender: UIDatePicker){
        let format = "HH:mm a"
        let text = sender.date
        let compText = text.toString(format: format)
        
        eventTime_label.text = compText
        
    }
    
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let format = "EEE, MMM d, yyyy"
        let datee = Date().toString(format: format)
        let text =  sender.date
        let compText = text.toString(format: format)
        
        if (compText?.toDate(format: format)!)! >= (datee?.toDate(format: format)!)!{
            
            eventDate_label.text = compText
        }else{
            print("es menor al dia de hoy")
            let alert = UIAlertController(title: "Tickr", message: "Date must be updated", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            present(alert, animated: true, completion: nil)
            alert.addAction(action)
        }
        
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

extension UIImagePickerController
{
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }
}



extension EventPlaneerControllerOne: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        venueName_label.text = place.name
        venueAddress_label.text = place.formattedAddress
        //        venueNamTextfield.text = place.name
        //        addressTextfield.text = place.formattedAddress
        //        phoneNumberTextfield.text = place.phoneNumber
        
        
        
        var typesArray : [String] = []
        
        for s in place.types{
            let typeSTR = s
            let newSTR = typeSTR.replacingOccurrences(of: "_", with: " ")
            typesArray.append(newSTR)
        }
        
        if let phonne = place.phoneNumber, let domain = place.website{
            
            venueDictionary = ["venue_name": place.name as AnyObject, "venue_type": typesArray.joined(separator: ",").capitalized as AnyObject, "venue_address": place.formattedAddress! as AnyObject, "venue_phone": phonne as AnyObject, "venue_domain": domain.absoluteString as AnyObject]
            
        }else{
            venueDictionary = ["venue_name": place.name as AnyObject, "venue_type": typesArray.joined(separator: ",").capitalized as AnyObject, "venue_address": place.formattedAddress! as AnyObject, "venue_phone": "phone number n/a" as AnyObject, "venue_domain": "website n/a" as AnyObject]
        }
        
        print("\(venueDictionary.keys), \(venueDictionary.values)")
        
        
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
