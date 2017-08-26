//
//  DetailsController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/21/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

protocol giveQRCode {
    func getQRCode(qrCode: CIImage)
}

class DetailsController: UIViewController {
    
    var qrDelegate : giveQRCode?
    
    
    var event : Event? = nil
    var qrCodeImage : CIImage!
    
    
    @IBOutlet weak var fb_sahreBUtton: FBSDKShareButton!
    @IBOutlet weak var description_view: UITextView!
    @IBOutlet weak var venue_label: UILabel!
    @IBOutlet weak var eventName_label: UILabel!
    @IBOutlet weak var background_iv: UIImageView!
    @IBOutlet weak var redeem_button: UIButton!
    @IBOutlet weak var showTicket_button: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///////SETUP View
        eventName_label.text = event?.event_name
        if let name = event?.event_venue{
        venue_label.text = "@\(name)"
        }else{
            venue_label.text = "To be anounced"
        }
        description_view.text = event?.event_description
        if let image = event?.event_image{
        let data = NSData(contentsOf: image as URL)
            background_iv.image = UIImage(data: data! as Data)
//            background_iv.image = UIImage(named: "arcticMonkeys")
        }else{
            background_iv.image = UIImage(named: "arcticMonkeys")
        }
        

         //Do any additional setup after loading the view.
        let contentURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/tickerandroidgood.appspot.com/o/Event_Images%2F363684801?alt=media&token=7dd28339-412a-461e-9bd0-7a3dc5764cc2")
       shareWithFB(image: (event?.event_image)! as URL, url: contentURL!, title: (event?.event_name)!, description: (event?.event_description)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareWithFB(image: URL, url: URL, title:String, description:String){
        
        // Create an object
        let properties: [AnyHashable: Any] = ["og:type": "article", "og:title": title, "og:description": description, "og:image": image, "og:url" : url]
        let object = FBSDKShareOpenGraphObject(properties: properties)
        // Create an action
        let action = FBSDKShareOpenGraphAction()
        action.actionType = "news.publishes"
        action.setObject(object, forKey: "article")
        
        let content = FBSDKShareOpenGraphContent()
        content.action = action
        content.previewPropertyName = "article"
        fb_sahreBUtton.shareContent = content
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "to_TicketDetails"{
            let sVC = segue.destination as! TicketViewController
            sVC.qrCodeImage = createTicket()
            print("HITTING SEGUE")
        }
        
        
        
    }
    
    @IBAction func redeemTicket(_ sender: Any) {
       
        
        let alert = UIAlertController(title: "Ticker!", message: "Do you accept to spend 50 points to redeem this ticket?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            // perhaps use action.title here
            self.redeem_button.isHidden = true
            self.showTicket_button.isHidden = false

        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
                
        print("create code")
        
        
            
        
    }
    
    func createTicket()-> CIImage{
        let data = event?.event_name.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        self.qrCodeImage = filter?.outputImage
        
        qrDelegate?.getQRCode(qrCode: self.qrCodeImage)
        
        return self.qrCodeImage
        
    }
    
    @IBAction func seeTicket(_ sender: Any){
        
        performSegue(withIdentifier: "to_TicketDetails", sender: self)
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



