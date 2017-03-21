//
//  LoginWebService.swift
//  SalonX
//
//  Created by DK on 28/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct LoginWebServices {
    
    func loginRequest(param: [String: String], completion: @escaping (Result<JSON>) -> Void) {
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.login()
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON{
            print($0.request)
            completion($0.result)
        }
    }
    
}
