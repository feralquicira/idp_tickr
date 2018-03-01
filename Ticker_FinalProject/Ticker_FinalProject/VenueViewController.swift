//
//  VenueViewController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/6/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit
import GooglePlaces


class VenueViewController: UIViewController {
    
    @IBOutlet weak var venueNamTextfield: UITextField!
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var venueTypeTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var venueWebsiteTextfield: UITextField!
    @IBOutlet weak var workingHoursTextfield: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        venueNamTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(_ sender:UITextField)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        print("writing")
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

extension VenueViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        venueNamTextfield.text = place.name
        addressTextfield.text = place.formattedAddress
        phoneNumberTextfield.text = place.phoneNumber
        
        print(place.rating)
        
        switch place.priceLevel {
        case .free:
            print("THis place is free")
            break
        case .cheap:
            print("THis place is cheap")
            break
        case .medium:
            print("THis place is kind of expensive")
            break
        case .high:
            print("THis place is expensive")
            break
        case .expensive:
            print("THis place is very expensive")
            
        default:
            print("Don't know how much to spend")
        }
        
        var typesArray : [String] = []
        
        for s in place.types{
            let typeSTR = s
            let newSTR = typeSTR.replacingOccurrences(of: "_", with: " ")
            typesArray.append(newSTR)
        }
        
        
        venueTypeTextfield.text = typesArray.joined(separator: ", ").capitalized
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
