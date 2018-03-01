//
//  RegistrationViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var company_textField: UITextField!
    @IBOutlet weak var password_textField: UITextField!
    @IBOutlet weak var password_scndTextField: UITextField!
    
    var segueID = "toPromoterDetail"
    var auth = Auth.auth()
    
    ///Database variables
    
    var databaseRef = DatabaseReference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try auth.signOut()
            print("sign out from firebase")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        print(Auth.auth().currentUser?.displayName ?? "no admin found")
        
        email_textField.delegate = self
        company_textField.delegate = self
        password_textField.delegate = self
        password_scndTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accountAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        if let email = email_textField.text, !email.isEmpty , let password = password_textField.text, !password.isEmpty, let company = company_textField.text,!company.isEmpty, let scndPassword = password_scndTextField.text, !scndPassword.isEmpty{
            if password == scndPassword{
                DispatchQueue.main.async {
                    self.createUserwithEmail(email: email, password: password, companyName: company)
                    
                    
                }
                
                
            }else{
                presentAlertWithCancel(message: "Your passwords don't match, try it again", button_title: "OK")
            }
        }else{
            presentAlertWithCancel(message: "Please provide the correct information in the fields", button_title: "OK")
        }
        
    }
    
    func createUserwithEmail(email: String, password: String, companyName: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Tcker", message: "Something went wrong with the registration", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                DispatchQueue.main.async {
                    let request = Auth.auth().currentUser?.createProfileChangeRequest()
                    request?.displayName = companyName
                    request?.commitChanges(completion: { (error) in
                        if error != nil{
                            print(error ?? "Error in create user with email RegistrationViewController")
                            return
                        }
                    })
                    Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                        if error != nil{
                            print(error.debugDescription)
                            return
                        }
                    })
                    
                    
                   
                }
                
               
                
            }
            DispatchQueue.main.async {
                Auth.auth().signIn(withEmail: email, password: password, completion: nil)
                 self.createUser(user_id: (Auth.auth().currentUser?.uid)!, user_email: email, company_name: companyName, password: password)
            }
        }
    }
    
    
    
    func presentAlertWithCancel(message: String, button_title: String){
        
        let alert = UIAlertController(title: "Tcker", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button_title, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createUser(user_id:String, user_email: String, company_name: String, password: String){
        let user = User(user_id: user_id, user_email: user_email)
        let user_object = [
            "user_id": user.user_id,
            "email": user.user_email,
            "company_name" : company_name
        ]
        
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: user_email, password: password, completion: { (user, error) in
                if error != nil{
                    print(error ?? "something happen in sign in")
                }else{
                    print(user?.displayName ?? "something here")
                    self.performSegue(withIdentifier: self.segueID, sender: self)
                }
                
                
            })
            Database.database().reference().child("Promotors").child(user_id).setValue(user_object)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        company_textField.resignFirstResponder()
        email_textField.resignFirstResponder()
        password_textField.resignFirstResponder()
        password_scndTextField.resignFirstResponder()
        return true
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
