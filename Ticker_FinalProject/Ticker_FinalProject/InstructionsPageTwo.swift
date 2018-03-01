//
//  InstructionsPageTwo.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/29/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class InstructionsPageTwo: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(colorLiteralRed: 44/255, green: 232/245, blue: 204/255, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 3.0
        
        
        
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
