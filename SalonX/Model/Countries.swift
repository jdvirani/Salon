//
//  Countries.swift
//  SalonX
//
//  Created by DK on 02/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation


struct Country {
    
    var county_id: String = "1"
    var county_name: String = ""
    var is_del: String = "0"
    
    init(county_id: String,county_name: String,is_del: String) {
        self.county_id = county_id
        self.county_name = county_name
        self.is_del = is_del
    }
}
