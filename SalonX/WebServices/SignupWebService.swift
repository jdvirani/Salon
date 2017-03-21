//
//  SignupWebService.swift
//  SalonX
//
//  Created by DK on 28/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON


struct SalonSignupWebService {
    
    func signUpRequest(param: [String: String], completion: @escaping (Result<JSON>) -> Void) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.salonSignUp()

        
            Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON(completionHandler: { (response) in
                print(response)
                completion(response.result)
            })
    }
}
