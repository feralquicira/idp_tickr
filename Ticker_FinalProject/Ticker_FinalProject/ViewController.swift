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


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //////////////IPAD SCREEN
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var password_textField: UITextField!
    
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var forgetPW_button: UIButton!
    
    
    
    
    //////////////////////////
    
    
    
    
    
    
    
    
    
    //GLOBAL VARIABLES
    var username = ""
    var user_image = ""
    var user_email = ""
    
    //DATABESE
    var databaseRef = DatabaseReference()
    
    
    @IBOutlet weak var fb_loginBUtton: FBSDKLoginButton!
    
    @IBOutlet weak var twitter_loginButton: UIButton!
    
    
    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SEtup Database
        
       databaseRef = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
        fb_loginBUtton.delegate = self
        if (FBSDKAccessToken.current() != nil){
            print("he is logged, he can move on")
            getFacebookUserInfo()
                     }else{
            fb_loginBUtton.readPermissions = ["public_profile", "email"]
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
               getFacebookUserInfo()
    
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
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                giveCredential(credential: credential)
                getFacebookUserInfo()
                
                
            }
        }
    }
    
    func giveCredential(credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print(error.localizedDescription)
                return
            }
            // User is signed in
            print("user firebase donde")
            let user_id = Auth.auth().currentUser?.uid
            self.createUser(user_id: user_id!, user_email: self.user_email)
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
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
                print(self.username)
                print(FBid ?? "np id")
                print(url as Any)
                self.moveToCitySelector(username: self.username, url: url!)
            })
            connection.start()
        }
    }
    
    func moveToCitySelector(username: String , url : NSURL ){
        if FBSDKAccessToken.current() != nil{
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "citySelector") as! SelectionCityViewController
            loginVC.username = username
            loginVC.url = url
            self.present(loginVC, animated: true, completion: nil)
            
        }
    }
    
    

    func newLogin(){
        Twitter.sharedInstance().logIn {
            (session, error) -> Void in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                print("YOUR USER ID IS: \(String(describing:session?.userID))")
                let credential = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                self.getTwitterInfo(clientID: (session?.userID)!)
                self.giveCredential(credential: credential)
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }

    }
    
    
    @IBAction func actologin(_ sender: Any) {
        self.newLogin()
        print("TOUCHING")
    }
    
    
    @IBAction func unwindToLoginScreen(sender: UIStoryboardSegue){
        //segue to go back to login screen
    }
    
    
    func getTwitterInfo(clientID: String){
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
        let params = ["id": clientID]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    func createUser(user_id:String, user_email: String){
        let user = User(user_id: user_id, user_email: user_email)
        let user_object = [
            "user_id": user.user_id,
            "user_email": user.user_email
        ]
        databaseRef.child("Users").child(user.user_id).setValue(user_object)
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if let email = email_textField.text, let password = password_textField.text{
        
        signInWithEmail(email: email, password: password)
        performSegue(withIdentifier: "to_mainAgenda", sender: self)
        }else{
            presentAlertWithCancel(message: "Put valid text", button_title: "OK")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_mainAgenda"{
            let sVC = segue.destination as? MasterViewController
            sVC?.promoter_name = email_textField.text!
        }
    }
    
    
    
    
    
    ////////////////////////////
    //    func twitter_login(){
    //        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
    //            if (session != nil) {
    //                print("signed in as \(String(describing: session?.userName))");
    //                let credential = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
    //
    //                self.giveCredential(credential: credential)
    //
    //            } else {
    //                print("error: \(String(describing: error?.localizedDescription))");
    //            }
    //        })
    //        logInButton.center = self.view.center
    //        self.view.addSubview(logInButton)
    //        
    //    }


}


extension ViewController{
    
    
    
    
    
    
    func createUserwithEmail(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Ticker", message: "Something went wrong with the registration", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.createUser(user_id: (Auth.auth().currentUser?.uid)!, user_email: email)
            }
        }
    }
    
    func signInWithEmail(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if error != nil{
                self.presentAlertWithCancel(message: "Your email or password are incorrect", button_title: "OK")
            }
        }
    }
    
    func presentAlertWithCancel(message: String, button_title: String){
        
        let alert = UIAlertController(title: "Ticker", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button_title, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}





