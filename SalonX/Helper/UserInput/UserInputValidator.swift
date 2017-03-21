//
//  UserInputValidator.swift
//  DNP
//
//  Created by Smit Sonani on 4/5/16.
//  Copyright © 2016 softices. All rights reserved.
//

import Foundation

/**
 *  Struct to perform validation on User input
 */
struct UserInputValidator {
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static func digitsOnly(text: String, range: NSRange, replacementString: String, maxLength: Int) -> Bool {
        let newLength = text.characters.count + replacementString.characters.count - range.length
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        let compSepByCharInSet = replacementString.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        return replacementString == numberFiltered && newLength <= maxLength
    }
    
    static func alphaNumericOnly(text: String, range: NSRange, replacementString: String, maxLength: Int) -> Bool {
        let newLength = text.characters.count + replacementString.characters.count - range.length
        
        let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789").inverted
        let compSepByCharInSet = replacementString.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        return replacementString == numberFiltered && newLength <= maxLength
    }
    
    static func nameOnly(text: String, range: NSRange, replacementString: String, maxLength: Int) -> Bool {
        let newLength = text.characters.count + replacementString.characters.count - range.length
        
        let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
        let compSepByCharInSet = replacementString.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        return replacementString == numberFiltered && newLength <= maxLength
    }
    
}
