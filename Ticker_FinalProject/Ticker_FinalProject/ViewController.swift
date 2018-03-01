//
//  ViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 7/31/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import TwitterKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    //////////////IPAD SCREEN
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var password_textField: UITextField!
    
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var forgetPW_button: UIButton!
    /////////////////////////////////////////////////////
    
    //GLOBAL VARIABLES
    var username = ""
    var user_image = ""
    var user_email = ""
    var profile_image = ""
    
    //DATABESE
    var databaseRef = DatabaseReference()
    
    
    //iPhone screen
    
    @IBOutlet weak var fb_loginBUtton: FBSDKLoginButton!
    
    @IBOutlet weak var userName_label: UITextField!
    
    @IBOutlet weak var password_label: UITextField!
    ////////////////////////////
    
    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            try Auth.auth().signOut()
            print("sign out from firebase")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //SEtup Databas
        
        password_label.delegate = self
        userName_label.delegate = self
        
        databaseRef = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
        fb_loginBUtton.delegate = self
        fb_loginBUtton.readPermissions = ["public_profile", "email", "user_friends"]
        
        if let aUser = Auth.auth().currentUser {
            print("Current user is jfjf \(String(describing: aUser.displayName))")
            //    performSegue(withIdentifier: "toInstructions", sender: self)
        }else{
            print("NO USER STARTING")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (Auth.auth().currentUser != nil){
            
            print("he is logged, he can move on")
            getFacebookUserInfo()
            // self.performSegue(withIdentifier: "toInstructions", sender: self)
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil)
        {
            // Process error
        }
        
        print("get credentials")
        
        
        showEmailFb()
    
    }
    
    func giveCredential(credential: AuthCredential){
        
        
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error ?? "THere is an error with FB")
                return
            }else{
                // User is signed in
                print("user firebase donde")
                let user_id = Auth.auth().currentUser?.uid
                Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { (snap) in
                    if snap.hasChild(user_id!){
                        
                        //self.performSegue(withIdentifier: "toInstructions", sender: self)
                        
                        return
                        
                    }else{
                        
                        self.createUser(user_id: user_id!, user_email: self.user_email, user_image: self.profile_image)
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.username
                        changeRequest?.photoURL = URL(string: self.profile_image)
                        Auth.auth().currentUser?.updateEmail(to: self.user_email, completion: { (error) in
                            if error != nil{
                                print(error as Any)
                            }
                            changeRequest?.commitChanges(completion: { (error) in
                                if error != nil{
                                    print("error")
                                    self.presentAlertWithCancel(message: "Registration Failed", button_title: "OK")
                                }
                                
                                // self.performSegue(withIdentifier: "toInstructions", sender: self)
                            })
                        })
                    }
                })
                
            }
            
        }
        
        
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    func showEmailFb(){
        
        let accesToken = FBSDKAccessToken.current()
        guard let accesTokenString = accesToken?.tokenString else
        { print("return")
            return}
        
        //print permissions, such as public_profile
        let credential = FacebookAuthProvider.credential(withAccessToken: accesTokenString)
        
        Auth.auth().signIn(with: credential) { (user, errno) in
            if let error = errno{
                print("wrong showEmailFb \(error)")
            }
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"]).start(completionHandler: { (connection, result, errno) in
                if errno != nil{
                    return
                }
                
                print(result!)
                let data = result as! [String : AnyObject]
                
                self.username = (data["name"] as? String)!
                self.user_email = (data["email"] as? String!)!
                print("FACEBOOK EMAIL IS: \(self.user_email)")
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                //self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                if let pic = url{
                    self.profile_image = String(describing: pic)
                    print(pic)
                }
                print(self.username)
                print(FBid ?? "np id")
                print(url as Any)
                print(self.profile_image)
                
                
                let user_id = Auth.auth().currentUser?.uid
                Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { (snap) in
                    if snap.hasChild(user_id!){
                        
                        print("it already exists, perform segue to instructions")
                        let userDeafaults = UserDefaults.standard
                        let tutorialPassed = userDeafaults.bool(forKey: "tutorialPassed")
                        if tutorialPassed{
                            print("tutorial already passed")
                            self.performSegue(withIdentifier: "toUserAgenda", sender: self)
                        }else{
                            self.performSegue(withIdentifier: "toInstructions", sender: self)
                        }
                        
                        return
                        
                    }else{
                        print("user don't exist, create user")
                        self.createUser(user_id: user_id!, user_email: self.user_email, user_image: self.profile_image)
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.username
                        changeRequest?.photoURL = URL(string: self.profile_image)
                        Auth.auth().currentUser?.updateEmail(to: self.user_email, completion: { (error) in
                            if error != nil{
                                print(error as Any)
                            }
                            changeRequest?.commitChanges(completion: { (error) in
                                if error != nil{
                                    print("error")
                                    self.presentAlertWithCancel(message: "Registration Failed", button_title: "OK")
                                }
                                
                                 self.performSegue(withIdentifier: "toInstructions", sender: self)
                            })
                        })
                    }
                }
                    
                    
                    
                )
            })
            
        }
        
        
    }
    
    func getFacebookUserInfo() {
        
        
        let accesToken = FBSDKAccessToken.current()
        guard let accesTokenString = accesToken?.tokenString else
        {return}
        
        //print permissions, such as public_profile
        _ = FacebookAuthProvider.credential(withAccessToken: accesTokenString)
        print(FBSDKAccessToken.current().permissions)
        
        
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            
            let data = result as! [String : AnyObject]
            
            self.username = (data["name"] as? String)!
            self.user_email = (data["email"] as? String!)!
            print("FACEBOOK EMAIL IS: \(self.user_email)")
            
            let FBid = data["id"] as? String
            
            let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
            //self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            if let pic = url{
                self.profile_image = String(describing: pic)
                print(pic)
            }
            print(self.username)
            print(FBid ?? "np id")
            print(url as Any)
            //self.moveToCitySelector(username: self.username, url: url!)
            //self.performSegue(withIdentifier: "toInstructions", sender: self)
            
        })
        connection.start()
        
    }
    
    func moveToCitySelector(username: String , url : NSURL ){
        if FBSDKAccessToken.current() != nil{
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "citySelector") as! SelectionCityViewController
            loginVC.username = username
            loginVC.url = url
            self.present(loginVC, animated: true, completion: nil)
            
        }
    }
    
    
    
    @IBAction func unwindToLoginScreen(sender: UIStoryboardSegue){
        //segue to go back to login screen
    }
    
    
    
    
    func createUser(user_id:String, user_email: String, user_image: String){
        let user = User(user_id: user_id, user_email: user_email)
        let user_object = [
            "user_id": user.user_id,
            "email": user.user_email,
            "user_image": user_image,
            "points":"0",
            "username":self.username,
            "member":"regular"
        ]
        databaseRef.child("Users").child(user.user_id).setValue(user_object)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_mainAgenda"{
            let sVC = segue.destination as? MasterViewController
            sVC?.promoter_name = email_textField.text!
        }
        
        if segue.identifier == "toSelection"{
            let sVC = segue.destination as!
            SelectionCityViewController
            
            sVC.username = "trying to log"
        }
        
//        if segue.identifier == "toUserAgenda"{
//            if let navController
//        }
        
        if segue.identifier == "toInstructions"{
            
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        if let email = userName_label.text, !email.isEmpty, let password = password_label.text, !password.isEmpty{
            DispatchQueue.main.async {
                self.signInWithEmail(email: email, password: password)
                print(Auth.auth().currentUser?.displayName as Any)
            }
            
            
            
        }else{
            presentAlertWithCancel(message: "Your email or password doesn't match", button_title: "OK")
        }
        
        
    }
    
    
    /*MISSING PROMOTER SIDE LOGIN*/
    
    @IBAction func promoterLogin(_ sender: Any){
        
        if let email = email_textField.text, !email.isEmpty, let password = password_textField.text, !password.isEmpty{
            self.signInWithEmailPromoter(email: email, password: password)
        }
        
    }
    
    
    
    
    
}


extension ViewController{
    
    func signInWithEmailPromoter(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if error != nil{
                self.presentAlertWithCancel(message: "Your email or password is incorrect", button_title: "OK")
            }else{
                print("you logged in succesfuly")
                //toSelection
                //self.performSegue(withIdentifier: "toInstructions", sender: (Any).self)
                print(Auth.auth().currentUser?.displayName ?? "no user in view controller")
                self.performSegue(withIdentifier: "toTabController", sender: self)
            }
        }
    }
    
    
    
    func signInWithEmail(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if error != nil{
                self.presentAlertWithCancel(message: "Your email or password is incorrect", button_title: "OK")
            }else{
                print("you logged in succesfuly")
                //toSelection
                //self.performSegue(withIdentifier: "toInstructions", sender: (Any).self)
                let userDeafaults = UserDefaults.standard
                let tutorialPassed = userDeafaults.bool(forKey: "tutorialPassed")
                if tutorialPassed{
                    print("tutorial already passed")
                    self.performSegue(withIdentifier: "toUserAgenda", sender: self)
                }else{
                    self.performSegue(withIdentifier: "toInstructions", sender: self)
                }
            }
        }
    }
    
    func presentAlertWithCancel(message: String, button_title: String){
        
        let alert = UIAlertController(title: "Ticker", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button_title, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func createUserWithFacebook(email:String, name: String, photo: NSURL ){
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName_label.resignFirstResponder()
        password_label.resignFirstResponder()
        return true
    }
    
    
    
}








