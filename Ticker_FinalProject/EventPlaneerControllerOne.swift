//
//  EventPlaneerControllerOne.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class EventPlaneerControllerOne: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var event_photoIv: UIImageView!
    
    @IBOutlet weak var eventName_label: UITextField!
    
    @IBOutlet weak var venueName_label: UITextField!
    
    @IBOutlet weak var venueAddress_label: UITextField!
    
    @IBOutlet weak var eventDate_label: UITextField!
    
    @IBOutlet weak var eventTime_label: UITextField!
    
    let imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
            
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                event_photoIv.image = image
            }
            else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                event_photoIv.image = image
            } else{
                print("Something went wrong")
            }
            event_photoIv.contentMode = .scaleToFill
            dismiss(animated:true, completion: nil)
        }

            
        
        
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//                event_photoIv.image = image
//            }
//            else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//                event_photoIv.image = image
//            } else{
//                print("Something went wrong")
//            }
//            event_photoIv.contentMode = .scaleToFill
//            dismiss(animated:true, completion: nil)
//        }
    
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
