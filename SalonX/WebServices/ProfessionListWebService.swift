//
//  ProfessionListWebService.swift
//  SalonX
//
//  Created by DK on 02/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

struct ProfesssionListWebService {
    
    func professionListRequest(param: [String: String], completion: @escaping (Result<JSON>) -> Void) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.professionListURL()
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            print(response.result.value)
            
            completion(response.result)
        }
        
    }
    
}
