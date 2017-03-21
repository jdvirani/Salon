//
//  LastMinuteOfferWebService.swift
//  SalonX
//
//  Created by DK on 08/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct LastMinuteOfferWebService {
    
    func lastMinuteOfferRequest(completion: @escaping (Result<JSON>) -> Void) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.lastMinuteOfferURL()
        
        let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())]
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            
            completion(response.result)
        }    
    }
}
