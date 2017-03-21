//
//  ManageSeviceWebService.swift
//  SalonX
//
//  Created by DK on 07/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ManageSeviceWebService {
    
    let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.manageService()
    
    func manageSeviceRequest(param: [String : String],completion: @escaping (Result<JSON>) -> Void) {
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            
            completion(response.result)
        }
        
    }
    
}
