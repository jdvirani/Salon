//
//  CategoryWebService.swift
//  SalonX
//
//  Created by DK on 07/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct CategoryWebService {
    
    func getCategoryListRequest(completion: @escaping (Result<JSON>) -> Void) {
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.categoryList()
        
        let param = [ R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id())]
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            print(response)
            completion(response.result)
        }
    }
}
