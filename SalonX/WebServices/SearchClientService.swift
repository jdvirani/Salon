//
//  SearchClientService.swift
//  SalonX
//
//  Created by DK on 21/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SearchClientService {
    func searchClientResquest(param: [String : String], completion: @escaping (Result<JSON>) -> Void) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.searchClient()
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            print(response)
            completion(response.result)
        }   
    }
}
