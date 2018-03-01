//
//  SelectionCityViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/16/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import Firebase

class SelectionCityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var cities : [String] = []
    var city = ""
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var username_label: UILabel!
    
    var username = ""
    var url : NSURL? = nil
    var t_user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = false
        cities = ["Orlando","Miami","Jacksonville"]
        
        if t_user != nil{
            print(t_user?.displayName ?? "No selection")
        }
        
        if let name = Auth.auth().currentUser?.displayName{
            username_label.text = "Hi, \(name)"
        }else{
            username_label.text = "Welcome"
        }
        
        
        print(Auth.auth().currentUser?.displayName ?? "NO USER FOUND")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        city = cities[picker.selectedRow(inComponent: 0)]
        print(city)
        
    }
    
    /*PICKER SETUP*///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        city = cities[picker.selectedRow(inComponent: 0)]
        print(city)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        if component == 0 {
            attributedString = NSAttributedString(string: cities[row],
            attributes: [NSForegroundColorAttributeName : UIColor.init(red: 44/255, green: 235/255, blue: 204/255, alpha: 1.0)])
        }
        
        return attributedString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainAgenda"{
            
            let dVC = segue.destination as! tabletestViewController
            
            dVC.url = self.url
            dVC.userName = self.username
        }
    }
    
    func fetchUser(){
        
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
