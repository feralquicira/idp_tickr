//
//  InstructionsPageOne.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/29/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class InstructionsPageOne: UIViewController {
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var awardView: UIView!
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var goView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI(view: shareView)
        setupUI(view: awardView)
        setupUI(view: ticketView)
        setupUI(view: goView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(view: UIView){
        
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = min(view.frame.size.height, view.frame.size.width) / 2.0
        view.clipsToBounds = true
        
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
