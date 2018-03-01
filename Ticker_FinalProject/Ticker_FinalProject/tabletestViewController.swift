//
//  tabletestViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/29/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class tabletestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, customSegueProtocol {
    
    /*IBOUTLETS*/
    @IBOutlet weak var userName_label: UILabel!
    @IBOutlet weak var userPoints_label: UILabel!
    @IBOutlet weak var profilePicture_iv: UIImageView!
    
    var refresher : UIRefreshControl!
    var url : NSURL? = nil
    var userName = ""
    var t_user = Auth.auth().currentUser
    var isGoing : Bool!
    var interested = 0
    var userIsGOing = false
    var myEvent : EventObject!
    
    var fireEvents = [EventObject]()
    var promotersList = [PromoterObject]()
    var promoterToPass = ""
    var localEvent = [Event]()
    var userEvents = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        setUI()
        tableView.delegate = self
        tableView.dataSource = self
        if t_user != nil{
            print("loged in as \(t_user?.displayName ?? "NO USER FOUND")")
            DispatchQueue.main.async {
                self.loadUser()
                DispatchQueue.main.async {
                    self.fetchEvents()
                    //self.fetchPromoters()
                }
                
            }
            
        }
        
//        refresher = UIRefreshControl()
//        refresher.attributedTitle = NSAttributedString(string: "Pull to refesh")
//        refresher.addTarget(self, action: #selector (refreshTable), for: .allEvents)
//        tableView.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillLayoutSubviews() {
        profilePicture_iv.layer.cornerRadius = profilePicture_iv.frame.height / 2.0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI(){
        _ = UINavigationBar.appearance()
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 70/255, alpha: 1.0)
            //=UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 70/255, alpha: 1.0)
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "tickr-logo")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
        
        
        profilePicture_iv.layer.borderWidth = 1
        profilePicture_iv.layer.masksToBounds = false
        profilePicture_iv.layer.borderColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        profilePicture_iv.layer.cornerRadius = profilePicture_iv.frame.height/2
        profilePicture_iv.clipsToBounds = true
    }
    
    @IBAction func logout(_ sender: Any) {
        DispatchQueue.main.async {
            
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            print("sign out from FACEBOOK")
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("sign out from firebase")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            self.performSegue(withIdentifier: "id_toMain", sender: self)
            
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fireEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agenda_cell" , for: indexPath) as! EventCell
        
        
        cell.setUpCell(event: fireEvents[indexPath.row])
        cell.vdelegate = self
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var interVal = 0
        
        let interested = UITableViewRowAction(style: .normal, title: "Interested") { (action, indexPath) in
            // share item at indexPath
            tableView.isEditing = false
            print("interested")
            let id = indexPath.row
            let event_id  = self.localEvent[id].id
            print(event_id)
            
            Database.database().reference().child("Events").child(event_id).observeSingleEvent(of: .value, with: { (snap) in
                if let observer = snap.value as? [String: AnyObject]{
                    if let inter = observer["interested"] as? String{
                    print("people interested \(inter)")
                        interVal = Int(inter)!
                        print("iiiiiii \(interVal)")
                         interVal += 1
                        let updateInterested = ["interested":String(interVal)]
                        Database.database().reference().child("Events").child(event_id).updateChildValues(updateInterested)
                        Database.database().reference().child("Promotors").child((self.myEvent?.promoterId)!).child("Events").child(event_id).updateChildValues(updateInterested)
                        interVal = 0
                        
                    }
                }
            })
            
            
        }
        
        interested.backgroundColor = UIColor(colorLiteralRed: 44/255, green: 235/255, blue: 204/255, alpha: 1.0)
        
        return [interested]
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(fireEvents[indexPath.row])
        performSegue(withIdentifier: "to_details", sender: (Any).self)
    }
    
    func callSegueFromButton(eventToPassID: String) {
        self.promoterToPass = eventToPassID
        self.performSegue(withIdentifier: "toPromoterProfile", sender: eventToPassID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_details"{
            let sVC = segue.destination as! DetailsController
            sVC.event = fireEvents[(tableView.indexPathForSelectedRow?.row)!]
        }
        
        
        if segue.identifier == "toPromoterProfile"{
//            var detail : PromoterProfileDetails
//            if let navController = segue.destination as? UINavigationController{
//                detail = navController.topViewController as! PromoterProfileDetails
//            }else{
               let detail = segue.destination as! PromoterProfileDetails
            //}
            
    
            detail.promoterID = self.promoterToPass
        }
    }
    
    func fetchPromoters(){
        Database.database().reference().child("Promotors").observe(.childAdded, with: { (data) in
            if let dictionary = data.value as? [String: AnyObject]{
                let promoter = PromoterObject()
                if let bio = dictionary["biography"] as? String,
                    let companyName = dictionary["company_name"] as? String,
                    let promoterDomain = dictionary["domain"] as? String,
                    let fbLink = dictionary["facebookLink"] as? String,
                    let profilePic = dictionary["profilePicture"] as? String,
                    let twLink = dictionary["twitterLink"] as? String,
                    let promoterId = dictionary["user_id"] as? String{
                    
                    promoter.biography = bio
                    promoter.companyName = companyName
                    promoter.promoterDomain = promoterDomain
                    promoter.facebookLink = fbLink
                    promoter.profilePicture = profilePic
                    promoter.twitterLink = twLink
                    promoter.promoterId = promoterId
                    
                    self.promotersList.append(promoter)
                    
                }
                
            }
        })
    }
    
    func fetchEvents(){
        Database.database().reference().child("Events").observe(.childAdded, with: { (data) in
            if let dictionary = data .value as? [String:AnyObject]{
                let event = EventObject()
                let _promoter = PromoterObject()
                // print(data)
                if let cost = dictionary["event_cost"] as? String, let date = dictionary["date"] as? String , let e_description = dictionary["event_description"] as? String, let e_hour = dictionary["event_hour"] as? String, let e_type = dictionary["event_type"] as? String, let name =  dictionary["name"] as? String, let photo = dictionary["photo"] as? String, let promoter = dictionary ["promoter"] as? String, let v_name = dictionary["venue_name"] as? String, let event_id = dictionary["event_id"] as? String, let redeem = dictionary["redeem"] as? String, let tickets = dictionary["free_tickets"] as?String, let vDictionary = dictionary["Venue"] as? [String: AnyObject], let promoterId = dictionary["promoter_id"] as? String{
                    
                    event.event_cost = cost
                    event.date = date
                    event.event_description = e_description
                    event.event_hour = e_hour
                    event.event_type = e_type
                    event.name = name
                    event.photo = photo
                    event.promoter = promoter
                    event.venue_name = v_name
                    event.event_id = event_id
                    event.pointsTo_redeem = redeem
                    event.freeTickets = tickets
                    event.venueDictionary = vDictionary
                    event.promoterId = promoterId
                    _promoter.promoterId = promoterId
                    
                    //event.photoHigh = photoHigh
                    self.myEvent = event
                    
                    
                    for ue in self.userEvents{
                        if event.event_id == ue{
                            print("USER IS GOING TO \(event.name)")
                            event.isGoing = true
                        }
                        
                        
                    }
                    
                    self.localEvent.append(Event(id: event_id))
                    
                    self.fireEvents.append(event)
                    self.promotersList.append(_promoter)
                    for e in self.fireEvents{
                        
                        let pastDate = e.date
                        //var dateString = date
                        let format = "EEE, MMM d, yyyy"
                        let datee = Date().toString(format: format)
                        print("current date is \(String(describing: datee))")
                        print("past date is \(String(describing: pastDate?.toDate(format: format)))")
                        if (datee?.toDate(format: format))! > (pastDate?.toDate(format: format)!)!{
                            print("remove event \(e.name)")
                            
                            self.fireEvents = self.fireEvents.filter{$0 != e}
                        }
                        
                    }
                    
                    
                    
                }else{
                    print("hay algo mal")
                }
                
                
                for e in self.fireEvents{
                    print("the remainig are \(e.name)")
                }
                
                print("people interested are \(self.interested)")
                self.tableView.reloadData()
                
                
            }
            
        })
        
        
        
    }
    
    func refreshTable(){
        
                self.fireEvents.removeAll()
            Database.database().reference().child("Events").observe(.childChanged, with: { (data) in
                if let dictionary = data .value as? [String:AnyObject]{
                    let event = EventObject()
                    // print(data)
                    if let cost = dictionary["event_cost"] as? String, let date = dictionary["date"] as? String , let e_description = dictionary["event_description"] as? String, let e_hour = dictionary["event_hour"] as? String, let e_type = dictionary["event_type"] as? String, let name =  dictionary["name"] as? String, let photo = dictionary["photo"] as? String, let promoter = dictionary ["promoter"] as? String, let v_name = dictionary["venue_name"] as? String, let event_id = dictionary["event_id"] as? String, let redeem = dictionary["redeem"] as? String, let tickets = dictionary["free_tickets"] as?String, let vDictionary = dictionary["Venue"] as? [String: AnyObject]{
                        
                        event.event_cost = cost
                        event.date = date
                        event.event_description = e_description
                        event.event_hour = e_hour
                        event.event_type = e_type
                        event.name = name
                        event.photo = photo
                        event.promoter = promoter
                        event.venue_name = v_name
                        event.event_id = event_id
                        event.pointsTo_redeem = redeem
                        event.freeTickets = tickets
                        event.venueDictionary = vDictionary
                        //event.photoHigh = photoHigh
                        
                        
                        for ue in self.userEvents{
                            if event.event_id == ue{
                                print("USER IS GOING TO \(event.name)")
                                event.isGoing = true
                            }
                            
                            
                        }
                        
                        self.localEvent.append(Event(id: event_id))
                        
                        self.fireEvents.append(event)
                        for e in self.fireEvents{
                            
                            let pastDate = e.date
                            //var dateString = date
                            let format = "EEE, MMM d, yyyy"
                            let datee = Date().toString(format: format)
                            print("current date is \(String(describing: datee))")
                            print("past date is \(String(describing: pastDate?.toDate(format: format)))")
                            if (datee?.toDate(format: format))! > (pastDate?.toDate(format: format)!)!{
                                print("remove event \(e.name)")
                                
                                self.fireEvents = self.fireEvents.filter{$0 != e}
                            }
                            
                        }
                        
                        
                        
                    }else{
                        print("hay algo mal")
                    }
                    
                    
                    for e in self.fireEvents{
                        print("the remainig are \(e.name)")
                    }
                    
                    print("people interested are \(self.interested)")
                    //self.tableView.reloadData()
                    self.refresher.endRefreshing()
                    
                    
                }
                
            })
                    
        
        
    }
    
    func find(objecToFind: EventObject?) -> Int? {
        for i in 0...fireEvents.count {
            if fireEvents[i] == objecToFind {
                return i
            }
        }
        return nil
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


extension tabletestViewController{
    
    func loadUser(){
        Database.database().reference().child("Users").child((t_user?.uid)!).observe(.value, with: { (DataSnapshot) in
            //print(DataSnapshot)
            if let dictionary = DataSnapshot.value as? [String: AnyObject]{
                if let name = dictionary["username"] as? String, let image = dictionary["user_image"] as? String, let points = dictionary["points"] as? String{
                    
                    
                    
                    self.userPoints_label.text = "\(points) points"
                    self.userName_label.text = name
                    if let data = NSData(contentsOf: URL(string: image)!){
                        self.profilePicture_iv.image = UIImage(data: data as Data)
                    }
                }
                if let events = dictionary["Events"] as? NSDictionary{
                    print("There are events")
                    for e in events{
                        self.userEvents.append(e.key as! String)
                        
                        
                    }
                }else{
                    print("THere are no events yet")
                }
            }else{
                print("data is bad read")
            }
            
            
        })
    }
    
    
    
    
    
    /*
     func loadUser(){
     Database.database().reference().child("Users").child((t_user?.uid)!).observe(.value, with: { (DataSnapshot) in
     //print(DataSnapshot)
     if let dictionary = DataSnapshot.value as? [String: AnyObject]{
     if let name = dictionary["username"] as? String, let image = dictionary["user_image"] as? String, let points = dictionary["points"] as? String, let venueDictionary = dictionary["Events"] as? NSDictionary{
     
     print(venueDictionary.allKeys)
     for events in venueDictionary{
     self.userEvents.append(events.key as! String)
     }
     
     
     
     self.userPoints_label.text = "\(points) points"
     self.userName_label.text = name
     if let data = NSData(contentsOf: URL(string: image)!){
     self.profilePicture_iv.image = UIImage(data: data as Data)
     }
     }
     }else{
     print("data is bad read")
     }
     
     
     })
     }
     */
    
}

extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}


