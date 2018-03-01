//
//  Extensions.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 9/10/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    
    
    func loadImageUsingCacheWithPhotoURL(string_url: String){
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: string_url as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        let url = URL(string: string_url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, reponse, error) in
            
            if error != nil{
                print(error ?? "extension cache")
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: string_url as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }
        
        dataTask.resume()
    
    }
    
}

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}



