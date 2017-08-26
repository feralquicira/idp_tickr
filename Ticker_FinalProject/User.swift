//
//  User.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/23/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import Foundation
import UIKit

class User{
    var user_email = ""
    var user_name = ""
    var user_last_name = ""
    var user_type = ""
    var user_id = ""
    
    
    
    init(user_id: String, user_email: String) {
        self.user_email = user_email
        self.user_id = user_id
    }
    
    
}
