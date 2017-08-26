//
//  MasterViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/25/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, CellListener {
    
    @IBOutlet weak var promoter_label: UILabel!
    
    
    var tableView : PromoterAgendaViewController?
    var pageOne : PromoterDetailsViewController?
    var promoter_name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        promoter_label.text = promoter_name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_pages" {
        let sVC = segue.destination as? PromoterDetailsViewController
         sVC?.eventName_label.text = "Perro"
            
         print("segueee")
        
        }
        if segue.identifier == "to_mainAgenda"{
            let sVC = segue.destination as? PromoterAgendaViewController
        }
    
    }
    
    func passEvent(event: EventPromoter) {
        pageOne?.eventName_label.text = event.event_name
        print("hitting delegate")
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
