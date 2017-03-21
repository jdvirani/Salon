//
//  Gloabal.swift
//  SalonX
//
//  Created by DK on 10/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

let appDelegate = UIApplication.shared.delegate as! AppDelegate


func getUserDetail(_ forKey: String) -> String{
    guard let userDetail = UserDefaults.standard.value(forKey: R.string.keys.userDetail()) as? NSData else { return "" }
    
    let data = JSON(userDetail)

    return data[forKey].stringValue
}

func isIndividualUser() -> Bool {

    return UserDefaults.standard.bool(forKey: "isIndividual")
 
}

func printData(text: String, item: Any) { 
    print("\(text) => \(item)")
}
