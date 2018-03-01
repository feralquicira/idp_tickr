//
//  PromoterProfileEditionViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/5/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class PromoterProfileEditionViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate {
    // Promoter Editing IBOutlets
    @IBOutlet weak var promoterImage: UIImageView!
    @IBOutlet weak var promoterNameLabel: UILabel!
    @IBOutlet weak var promoterEditTexBio: UITextView!
    @IBOutlet weak var domainText: UITextField!
    @IBOutlet weak var facebookLinkText: UITextField!
    @IBOutlet weak var tweeterLinkText: UITextField!
    
    //Result IBOutlet
    @IBOutlet weak var resultImageProfile: UIImageView!
    @IBOutlet weak var resultPromoterNameLabel: UILabel!
    @IBOutlet weak var resultTextEdit: UITextView!
    @IBOutlet weak var resultDomainLabel: UILabel!
    @IBOutlet weak var resultFacebookLabel: UILabel!
    @IBOutlet weak var resultTweeterLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var socialView: UIView!
    
    var segueID = "toPromoterTable"
    
    var userID  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = Auth.auth().currentUser?.uid{
        userID = id
        }else{
            print("NO ID")
        }
        
        promoterNameLabel.text = Auth.auth().currentUser?.displayName
        resultPromoterNameLabel.text = Auth.auth().currentUser?.displayName
        
        setUI()
        
        promoterEditTexBio.delegate = self
        giveGestureToImage()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        domainText.addTarget(self, action: #selector(completePromoterEdit(_:)), for: .editingChanged)
        facebookLinkText.addTarget(self, action: #selector(completePromoterEdit(_:)), for: .editingChanged)
        tweeterLinkText.addTarget(self, action: #selector(completePromoterEdit(_:)), for: .editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resultTextEdit.text = promoterEditTexBio.text
    }
    
    
    func completePromoterEdit(_ editText: UITextField){
        resultDomainLabel.text = domainText.text
        resultFacebookLabel.text = facebookLinkText.text
        resultTweeterLabel.text = tweeterLinkText.text
    }
    
    
    //Add image Gesture
    func giveGestureToImage(){
        promoterImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (touchPicture)))
        promoterImage.isUserInteractionEnabled = true
    }
    
    func touchPicture(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            promoterImage.image = image
            resultImageProfile.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishAction(_ sender: Any) {
        
        if let bio = promoterEditTexBio.text, !bio.isEmpty, let p_domain = domainText.text, !p_domain.isEmpty, let fb = facebookLinkText.text, !fb.isEmpty, let tw = tweeterLinkText.text, !tw.isEmpty{
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("PromoterImages").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.promoterImage.image!, 0.3){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error ?? "NO METADA FOUND EDIT PROFILE SCREEN")
                        return
                    }
                    if let urlPic = metadata?.downloadURL()?.absoluteURL{
                        let request = Auth.auth().currentUser?.createProfileChangeRequest()
                        request?.photoURL = urlPic
                        request?.commitChanges(completion: { (error) in
                            if error != nil{
                                return
                            }
                        })
                    }
                    
                    if let imageProfile = metadata?.downloadURL()?.absoluteString{
                        
                        
                        let promoterInfo = ["biography":bio,
                                            "domain": p_domain,
                                            "facebookLink":fb,
                                            "twitterLink":tw,
                                            "profilePicture": imageProfile]
                        DispatchQueue.main.async {
                            Database.database().reference().child("Promotors").child(self.userID).updateChildValues(promoterInfo)
                        }
                        
                        
                    }
                    
                })
            }
           self.performSegue(withIdentifier: self.segueID, sender: self)
            
        }else{
            presetAlertController()
        }
        
    }
    
    
    //
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PromoterProfileEditionViewController{
    
    func setUI(){
        promoterEditTexBio.layer.borderWidth = 1.0
        promoterEditTexBio.layer.borderColor = UIColor(colorLiteralRed: 44/255, green: 235/255, blue: 204/255, alpha: 1.0).cgColor
        promoterEditTexBio.layer.cornerRadius = 5.0
        
        socialView.layer.borderWidth = 1.0
        socialView.layer.borderColor = UIColor(colorLiteralRed: 44/255, green: 235/255, blue: 204/255, alpha: 1.0).cgColor
        socialView.layer.cornerRadius = 5.0
    }
    
    func presetAlertController(){
        let alert = UIAlertController(title: "Tickr", message: "Please fill all information", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
