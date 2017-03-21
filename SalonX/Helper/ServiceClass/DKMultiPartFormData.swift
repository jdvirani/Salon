//
//  DKMultiPartFormData.swift
//  EasyJob
//
//  Created by DK on 10/10/16.
//  Copyright © 2016 Jitendra Bhadja. All rights reserved.
//

import UIKit


import Foundation
protocol DKMultiPartForm: class
{
    func appendData(data:Data, Key key: String,fileName:String)
    func appendData(data:Data, Key key: String,fileName:String,mimeType:String)
    func appendParams(Params value: String, Key key: String)
}

let boundary = "---------------------------14737809831466499882746641449"

class DKMultiPartFormData: NSObject , DKMultiPartForm {

    var body: NSMutableData!

    
    convenience init(body bodyData: NSMutableData) {
        self.init()
        self.body = bodyData
    }
    
    func appendData(data:Data, Key key: String,fileName:String,mimeType:String) {
        
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    }
    func appendData(data:Data, Key key: String,fileName:String) {
        
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    }

    func appendParams(Params value: String, Key key: String) {
        
        body.append((String(format: "--%@\r\n",boundary).data(using: .utf8))!)
        body.append((String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key as NSString).data(using: .utf8))!)
        body.append((String(format: "%@",value as NSString).data(using: .utf8))!)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
//        let boundary = "---------------------------14737809831466499882746641449"
//        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData("\(eventName)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
}

