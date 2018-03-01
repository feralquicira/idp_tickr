//
//  MasterViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var eventName_label: UILabel!
    
    @IBOutlet weak var venueName_label: UILabel!
    
    @IBOutlet weak var textView_box: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var fireEvents = [EventObject]()
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    @IBOutlet weak var promoter_label: UILabel!
//     var events : [EventPromoter] = [EventPromoter.init(event_cost: "60", event_date: "Fri, Aug 29, 2017", event_description: "\"Arctic Monkeys are a guitar rock band from Sheffield, England. The group, which is comprised of frontman and lyricist Alex Turner, guitarist Jamie Cook, drummer Matt Helders and bassist Nick O’Malley, are one of the most successful British bands of the 21st century: their debut album ‘Whatever People Say I Am, That’s What I’m Not’ is the fastest-selling debut in British chart history and they have released five consecutive Number One albums. They have released two albums, ‘Whatever…’ and their most recent LP ‘AM’, which have received 10/10 reviews from NME. Other accolades and achievements include winning seven Brit Awards and headlining Glastonbury Festival on two occasions.\" ", event_time: "9:00pm", event_type: "Premium", event_name: "Arctic Monkeys", event_image: NSURL(string: "https://i.ytimg.com/vi/bpOSxM0rNPM/hqdefault.jpg")!, event_venue: "Hard Rock Hotel", event_promoter:  "Live Nation")]
    
    
   
    var promoter_name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("FIRE USER IS \(Auth.auth().currentUser?.displayName ?? "IDK who he is")" )
        fetchEvents()
        promoter_label.text = promoter_name
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fireEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_promoterCell" , for: indexPath) as! PromoterCell
    
            cell.setUpCell(event: fireEvents[indexPath.row])
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...fireEvents.count:
            eventName_label.text = fireEvents[indexPath.row].name
            venueName_label.text = fireEvents[indexPath.row].venue_name
            let data = NSData(contentsOf: URL(string: fireEvents[indexPath.row].photo!)!)
            
            if data != nil{
                
                self.backgroundImage.image = UIImage(data: data! as Data)
            }else{
                self.backgroundImage.image = UIImage(named: "party")
            }
            textView_box.text = fireEvents[indexPath.row].event_description
        default:
            break
        }
    }
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            fireEvents.remove(at: indexPath.row)
            mainTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
    // Fetch events from FIREBASE
    func fetchEvents(){
        Database.database().reference().child("Events").observe(.childAdded, with: { (data) in
            if let dictionary = data .value as? [String:AnyObject]{
                let event = EventObject()
                print(data)
                if let cost = dictionary["event_cost"] as? String, let date = dictionary["date"] as? String , let e_description = dictionary["event_description"] as? String, let e_hour = dictionary["event_hour"] as? String, let e_type = dictionary["event_type"] as? String, let name =  dictionary["name"] as? String, let photo = dictionary["photo"] as? String, let promoter = dictionary ["promoter"] as? String, let v_name = dictionary["venue_name"] as? String {
                    
                    event.event_cost = cost
                    event.date = date
                    event.event_description = e_description
                    event.event_hour = e_hour
                    event.event_type = e_type
                    event.name = name
                    event.photo = photo
                    event.promoter = promoter
                    event.venue_name = v_name
                    
                    self.fireEvents.append(event)
                    
                }else{
                    print("hay algo mal")
                }
                
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
                
                
                
                
                
            }
            
        })
        
        self.loadingLabel.isHidden = true
        
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
