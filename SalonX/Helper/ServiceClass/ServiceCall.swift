//
//  ServiceCall.swift
//  EasyJob
//
//  Created by DK on 10/10/16.
//  Copyright © 2016 Jitendra Bhadja. All rights reserved.
//

import UIKit

typealias Completion = (_ success:Bool , _ result:Any) ->Void
enum ContentType {
    case json
    case wForm
    case multiPartForm
}
struct Type {
   static let JSON = "application/json"
   static let WForm = "application/x-www-form-urlencoded"
   static let MultiPartForm = "multipart/form-data; boundary=---------------------------14737809831466499882746641449"
};

class ServiceCall: NSObject,NSURLConnectionDelegate,NSURLConnectionDataDelegate {

    var dataVal = NSMutableData()
    var request: NSMutableURLRequest? = nil
    private var content:String = ""
    private var contentType:ContentType = .wForm {
        didSet {
            // Update empty image views
            
            switch contentType {
            case .wForm:
                content = Type.WForm
                break
            case .json:
                content = Type.JSON
                break
            case .multiPartForm:
                content = Type.MultiPartForm
                break
            }
        }
    }
    
    private var completion: Completion = { success, result in print(result) }
    var downloadProgressBlock:(_ progress:Float) -> Void = {(progress:Float) -> Void in
        // set progress How may bytes download the data
    }
    var uploadProgressBlock:(_ progress:Float) -> Void = {(progress:Float) -> Void in
        // set progress How may bytes upload the data
    }
    private var expectedBytes:Int64!
    
    convenience init(URL url:String){
        self.init()
        request = NSMutableURLRequest.init(url: URL(string: url)!)
    }
    
    func setAuthorization(username:String , password:String)
    {
        let PasswordString =  String(format: "\(username):\(password)") // "usr_easyjob:3a8wGTszSJWU2J99"
        let PasswordData = PasswordString.data(using: .utf8)
        let base64EncodedCredential = PasswordData!.base64EncodedString(options: .lineLength64Characters)
        request!.setValue("Basic \(base64EncodedCredential)", forHTTPHeaderField: "Authorization")
    }
    
    
    func setContentType(contentType:ContentType)
    {
        self.contentType = contentType
    }
    // MARK: - POST METHOD
    func POST(parameters: Any, CompletionBlock:@escaping Completion)
    {
        if Rechability.isConnectedToNetwork() {
            dataVal = NSMutableData()
            
            let body = NSMutableData()
            request!.setValue(content, forHTTPHeaderField: "content-type")
            let MultiPartData = DKMultiPartFormData(body: body)
            
            for (key, value) in parameters as! NSDictionary
            {
                MultiPartData.appendParams(Params: value as! String, Key: key as! String)
            }
            
            request!.httpMethod = "POST"
            request!.httpBody = body as Data
            completion = CompletionBlock
            
            request!.timeoutInterval = 300
            
            let connection: NSURLConnection = NSURLConnection(request: request! as URLRequest, delegate: self, startImmediately: true)!
            connection.start()
        }
        else {
            CompletionBlock(false,"Please check your internet connection")
        }
    }
    
    func POST(params parameters: NSDictionary, appendBodyWithBlock block: (_ formData: DKMultiPartForm) -> Void , CompletionBlock:@escaping Completion)
    {
        if Rechability.isConnectedToNetwork() {
            
            dataVal = NSMutableData()
            let body = NSMutableData()
            
            request!.httpMethod = "POST"
            request!.setValue(content, forHTTPHeaderField: "Content-Type")
            
            let MultiPartData = DKMultiPartFormData(body: body)
            
            for (key, value) in parameters
            {
                MultiPartData.appendParams(Params: value as! String, Key: key as! String)
            }
            
            block(MultiPartData)
            
            request!.httpBody = body as Data
            
            request!.timeoutInterval = 300
            
            completion = CompletionBlock
            
            let connection: NSURLConnection = NSURLConnection(request: request! as URLRequest, delegate: self, startImmediately: true)!
            
            connection.start()
        }
        else {
            CompletionBlock(false, "Please check your internet connection")
        }
    }
    // MARK: - Json Conversion
    
    func convertDictionaryToJson(theDict: NSMutableDictionary) -> String
    {
        let newData = try! JSONSerialization.data(withJSONObject: theDict, options: .prettyPrinted)
            let jsonString = String(data: newData, encoding:.utf8)
            return jsonString!
    }
    func getDictionaryFromJson(jsonData: String) ->  Any
    {
        let newData = jsonData.data(using: .utf8)
        let newDict = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
        return newDict
    }
    
    //MARK: Connection delegate method
    
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.dataVal.length = 0
        expectedBytes = response.expectedContentLength
    }
    func connection(_ connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        let progressive = Float(totalBytesWritten) / Float(expectedBytes == nil ? Int64(totalBytesWritten + totalBytesExpectedToWrite) : expectedBytes)
        self.uploadProgressBlock(progressive)
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.dataVal.append(data)
        let progressive = Float(self.dataVal.length) / Float(expectedBytes)
        self.downloadProgressBlock(progressive)
    }
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        completion(false, error.localizedDescription)
        return
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        do {
            var jsonResult:Any
            jsonResult = try JSONSerialization.jsonObject(with: dataVal as Data, options: .mutableContainers)
            completion(true,jsonResult)
        }
        catch let error {
            completion(false,error.localizedDescription)
        }
        
    }
}
