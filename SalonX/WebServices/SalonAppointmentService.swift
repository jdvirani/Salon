//
//  SalonAppointmentService.swift
//  SalonX
//
//  Created by DK on 21/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SalonAppointmentService {
    
    func getAppointmenteRequest(param: [String : String], completion: @escaping (Result<JSON>) -> Void) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.salonAgendaAppointmentURL()
        
        Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
            print(response)
            completion(response.result)
        }
    }
}

//let param = [R.string.keys.lang() : Language.shared.Lang,
//             R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
//             R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
//             "flag_view" : "0",
//             "date" : "\(Date())",
//    "emp_id" : "11"]
//
//if Rechability.isConnectedToNetwork() {
//    BasicStuff.showLoader(self.view)
//    
//    SalonAppointmentService().getAppointmenteRequest(param: param, completion: { (result) in
//        BasicStuff.dismissLoader()
//        print(result.value)
//        if let json = result.value {
//            if json[R.string.keys.flag()].stringValue == "1" {
//                print("success")
//            }
//        }
//    })
//}
