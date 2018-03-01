//
//  RegistratioUserController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/28/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class RegistratioUserController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var userName_textfield: UITextField!
    
    @IBOutlet weak var email_textfield: UITextField!

    @IBOutlet weak var password_textfield: UITextField!
    
    @IBOutlet weak var confirmPassword_textfield: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var photoURL : String?
    
    
    var id_segue = "toInstructions"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        giveGestureToImage()
        userName_textfield.delegate = self
        email_textfield.delegate = self
        password_textfield.delegate = self
        confirmPassword_textfield.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToMain(_ sender: Any) {
        
        self.performSegue(withIdentifier: "id_toMain", sender: self)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        if let email = email_textfield.text, !email.isEmpty, let passwor = password_textfield.text,!passwor.isEmpty, let c_password = confirmPassword_textfield.text, !c_password.isEmpty, let username = userName_textfield.text, !username.isEmpty{
        
                Auth.auth().createUser(withEmail: email, password: passwor, completion: { (cuser, error) in
                    if error != nil{
                        
                    }else{
                        let request = cuser?.createProfileChangeRequest()
                        request?.displayName = username
                        request?.commitChanges(completion: { (commitError) in
                            if commitError != nil{
                                print("user has no name")
                                return
                            }
                        })
                        cuser?.updateEmail(to: email, completion: { (e_error) in
                            if e_error != nil{
                                return
                            }
                        })
                        
                        print("\(cuser?.displayName ?? "NO NAME TO DISPLAY"), \(cuser?.email ?? "NO VALID EMAIL")")
                    }
                    
                    if let aUser = Auth.auth().currentUser{
                        print("Current user is \(aUser.displayName ?? "NO USER")")
                    }
                    
                    DispatchQueue.main.async {
                        
                        Auth.auth().signIn(withEmail: email, password: passwor, completion: { (sUser, sError) in
                            if sError != nil{
                                return
                            }else{
                                
                                print(sUser?.displayName as Any)
                                DispatchQueue.main.async {
                                    
                                    self.createUser(user_id: (sUser?.uid)!, user_email: (sUser?.email)!, username: (sUser?.displayName)!)
                                    
                                }
                                
                            }
                        })
                        
                    }
                    
                    
                })
                
            
            
            
            
            

        }
        

}//ende ibaction
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == id_segue{
        }
    }

    

    func presentAlertWithCancel(message: String, button_title: String){
        
        let alert = UIAlertController(title: "Ticker", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button_title, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createUser(user_id:String, user_email: String, username: String){
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("UserImages").child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error as Any)
                    return
                }
                
                if let urlpic = metadata?.downloadURL(){
                    let u = Auth.auth().currentUser
                    let r = u?.createProfileChangeRequest()
                    r?.photoURL = urlpic
                }
                
                if let imageProfile = metadata?.downloadURL()?.absoluteString{
                    
                    
                    self.photoURL = imageProfile
                    
                    let databaseRef = Database.database().reference()
                    
                    let user = User(user_id: user_id, user_email: user_email)
                    let user_object = [
                        "user_id": user.user_id,
                        "email": user.user_email,
                        "username" : username,
                        "user_image" : imageProfile,
                        "points":"0",
                        "shared":"0",
                        "tweeted":"0",
                        "member":"regular"
                        
                    ]
                    DispatchQueue.main.async {
                        databaseRef.child("Users").child(user.user_id).setValue(user_object)

                    }
                    self.performSegue(withIdentifier: "toInstructions", sender: self)
                    
                }else{
                    self.presentAlertWithCancel(message: "You need to select a profile picture", button_title: "OK")
                }
                
            })
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

extension RegistratioUserController{
    
    func giveGestureToImage(){
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (touchPicture)))
        profileImage.isUserInteractionEnabled = true
    }
    
    func touchPicture(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("\(info)")
        if let image  = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func signInWithUser(email: String, password: String, photo : URL ){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error as Any)
            }else{
                
                
            }
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName_textfield.resignFirstResponder()
        password_textfield.resignFirstResponder()
        confirmPassword_textfield.resignFirstResponder()
        email_textfield.resignFirstResponder()
        return true
    }
    
}
