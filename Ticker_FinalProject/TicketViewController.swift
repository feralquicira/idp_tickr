//
//  TicketViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/23/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, giveQRCode {
    
    @IBOutlet weak var bcgroundImage: UIImageView!
    
    @IBOutlet weak var eventName_label: UILabel!
    
    @IBOutlet weak var eventDate_label: UILabel!
    
    @IBOutlet weak var ticketImage: UIImageView!
    
    @IBOutlet weak var promoterName_label: UILabel!
    
    var event : EventObject?
    var eventID = ""
    
    
    var qrCodeImage : CIImage!
    
    @IBOutlet weak var qrImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayQRCode()
        setUI(event: event!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getQRCode(qrCode: CIImage){
        self.qrCodeImage = qrCode
        print("we have a code")
        qrImageView.image = UIImage(ciImage: qrCode)
    }
    
    func displayQRCode(){
        let scaleX = qrImageView.frame.size.width / self.qrCodeImage.extent.size.width
        let scaleY = qrImageView.frame.size.height / self.qrCodeImage.extent.size.height
        
        let transformedImage = self.qrCodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        qrImageView.image = UIImage(ciImage: transformedImage)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI(event: EventObject){
        
        let data = NSData(contentsOf: URL(string: event.photo!)!)
        
        if data != nil{
            
            bcgroundImage.image = UIImage(data: data! as Data)
            ticketImage.image = UIImage(data: data! as Data)
        }else{
            bcgroundImage.image = UIImage(named: "party")
            ticketImage.image = UIImage(named: "party")
        }
        
        
        eventName_label.text = event.name
        eventDate_label.text = event.date
        promoterName_label.text = event.promoter
        
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
