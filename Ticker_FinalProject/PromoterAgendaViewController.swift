//
//  PromoterAgendaViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

protocol CellListener : class {
    func passEvent(event: EventPromoter)
}

class PromoterAgendaViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var promoter_label: UILabel!
    
    static var name = ""
    static var event_description = ""
    static var venue = ""
    var promoter_name = ""
    
    var eventListener : CellListener?
    
    var events : [EventPromoter] = [EventPromoter.init(event_cost: "60", event_date: "Fri, Aug 29, 2017", event_description: "\"Arctic Monkeys are a guitar rock band from Sheffield, England. The group, which is comprised of frontman and lyricist Alex Turner, guitarist Jamie Cook, drummer Matt Helders and bassist Nick O’Malley, are one of the most successful British bands of the 21st century: their debut album ‘Whatever People Say I Am, That’s What I’m Not’ is the fastest-selling debut in British chart history and they have released five consecutive Number One albums. They have released two albums, ‘Whatever…’ and their most recent LP ‘AM’, which have received 10/10 reviews from NME. Other accolades and achievements include winning seven Brit Awards and headlining Glastonbury Festival on two occasions.\" ", event_time: "9:00pm", event_type: "Premium", event_name: "Arctic Monkeys", event_image: NSURL(string: "https://i.ytimg.com/vi/bpOSxM0rNPM/hqdefault.jpg")!, event_venue: "Hard Rock Hotel", event_promoter:  "Live Nation")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_promoterCell" , for: indexPath) as! PromoterCell
        
        for event in self.events{
            
            cell.setUpCell(event: event)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        PromoterAgendaViewController.name = events[row].event_name
        self.eventListener?.passEvent(event: events[row])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
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
