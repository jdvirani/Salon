//
//  ManageEmployeeService.swift
//  SalonX
//
//  Created by DK on 08/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ManageEmployeeService {
    
    func manageEmployeeRequest(param: [String : String], completion: @escaping (Result<JSON>) -> Void) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.manageEmployeeURL()
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            
            completion(response.result)
        }
        
    }
    
}
