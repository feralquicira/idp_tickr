//
//  TicketViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/23/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, giveQRCode {
    
    var qrCodeImage : CIImage!
    
    @IBOutlet weak var qrImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayQRCode()
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
