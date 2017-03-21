//
//  String+Validations.swift
//  SalahNearby
//
//  Created by Jaydeep Vora on 15/06/16.
//  Copyright © 2016 softices. All rights reserved.
//

import Foundation
public extension String {
    
    public var length: Int { return self.characters.count }
    
    public func toURL() -> NSURL? {
        return NSURL(string: self)
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func toDate(format : String = "yyyy-MM-dd") -> NSDate? {
        let text = self.trimmed().lowercased()
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = format
        return dateFmt.date(from: text) as NSDate?
    }
    
    //    subscript (r: Range<Int>) -> String {
    //        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    //
    //    }
    
    func isEmail() throws -> Bool {
        let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
        return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
    }
    
    func isAlphaSpace() throws -> Bool {
        let regex = try NSRegularExpression(pattern: "^[A-Za-z ]*$", options: [])
        return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, characters.count)) != nil
    }
    
    func isNumeric() throws -> Bool {
        let regex = try NSRegularExpression(pattern: "^[0-9]*$", options: [])
        
        return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, characters.count)) != nil
    }
    
    func isRegistrationNumber() throws -> Bool {
        let regex = try NSRegularExpression(pattern: "^[A-Za-z0-9 ]*$", options: [])
        
        return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, characters.count)) != nil
    }
    
    func isValidDate(dateFormat: String) -> Bool {
        if self.toDate(format: dateFormat) == nil {
            return false
        }
        return true
    }
    
}

public extension String {
    
    func validateFirstName() -> Bool {
        do {
            if !(try self.isAlphaSpace()) {
                return false
            }
        } catch {
            return false
        }
        
        return true
    }
    
    func validateEmail() -> String {
        if self.length == 0 {
            return LocalizedString(key: "enterEmailAddress\n")
        } else {
            do {
                if !(try self.isEmail()) {
                    return LocalizedString(key: "invalidEmail\n")
                }
            } catch {
                return LocalizedString(key: "invalidEmail\n")
            }
        }
        
        return ""
    }
    
    func validatePassword() -> String {
        if self.length == 0 {
            return LocalizedString(key: "passwordCantBlank\n")
        } else if self.length < 6 {
            return LocalizedString(key: "InvaidPassword\n")
        }
        
        return ""
    }
    
}



