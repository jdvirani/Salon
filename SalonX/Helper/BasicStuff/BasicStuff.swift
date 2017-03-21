//
//  BasicStuff.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit
import SVProgressHUD

//MARK:- Default Keys
let LANG_KEY            = "default_lang"
let ALERT_TITLE         = LocalizedString(key:"Alert")
let Default = UserDefaults.standard
let MainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
let Key_DeviceToken     = "device_token"
let Key_ClientUserDetail = "ClientUserDetail"
let Key_ClientWithoutCerdential = "ClientWithoutCerdential"
let Key_IsLogin = "IsLogin"


struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

enum language {
    case `default`
    case English
    case Romanian
}
let Romanian = "Ro"
let English = "En"
class Language {
    
    static let shared = Language()
    var isEnglish:Bool  = true
    var Lang = "0"
    
    init() {
        isEnglish = true
        Lang = "0"
    }
    func set(lang : language)
    {
        switch lang
        {
        case .English:
            isEnglish = true
            Lang = "0"
            Default.set(English, forKey: LANG_KEY)
            break
        case .Romanian:
            isEnglish = false
            Lang = "1"
            Default.set(Romanian, forKey: LANG_KEY)
            break
        case .default:
            if Default.value(forKey: LANG_KEY) == nil
            {
                isEnglish = true
                Lang = "0"
                Default.set(English, forKey: LANG_KEY)
            }
            else if Default.string(forKey: LANG_KEY) == "En"
            {
                isEnglish = true
                Lang = "0"
                Default.set(English, forKey: LANG_KEY)
            }
            else
            {
                isEnglish = false
                Lang = "1"
                Default.set(Romanian, forKey: LANG_KEY)
            }
            break
        }
        
        Default.synchronize()
    }
}

func LocalizedString(key:String) -> String {
    let language:String!
    
    if Language.shared.isEnglish
    {
        language = "Base"
    }
    else
    {
        language = "ro"
    }
    let path = Bundle.main.path(forResource: language, ofType: "lproj")
    let bundle = Bundle(path: path!)
    
    return (bundle?.localizedString(forKey: key, value: "", table: nil))!
}

class BasicStuff: NSObject {
    
    static let basic = BasicStuff()
    let timeZone:String = TimeZone.current.identifier
    //    var isNetworkRechable:Bool = false
    let deviceType         = "1"
    var deviceToken:String = getDefaultDeviceToken()
    var setLeftMenuSelected:NSDictionary!
    var dateFormate = DateFormatter()
    var IsFromScreen:String!
    var storeBookingDetail:NSDictionary!

    override init() {
        super.init()
        IsFromScreen = ""
        //        rechability = Rechability()
        setLeftMenuSelected = ["section":0,"indexpath":0]
        storeBookingDetail = NSDictionary()

    }
    
    class func showAlert(title:String,message:String) {
        UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok").show()
    }
    class func showLoader(_ view:UIView) {
        
        //#define SV_APP_EXTENSIONS 1
        SVProgressHUD.setViewForExtension(view)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show(withStatus: "Loading...")
    }
    class func showLoader(_ view:UIView,progress:Float) {
        SVProgressHUD.setViewForExtension(view)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.showProgress(progress, status: "Uploading...")
    }
    
    class func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
    class func setStrikethroughStyleAttributeedText(_ text:String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString;
    }
    
    //    MARK:- ClienDetailWithoutCerdential Data in UserDefult
    class func saveClienDetailWithoutCerdential(_ Dicdata:NSDictionary) {
        Default.setValue(Dicdata, forKey: Key_ClientWithoutCerdential)
        Default.synchronize()
    }
    class func getClienDetailWithoutCerdential(_ forKey: String) -> String{
        guard let ClientAccessDetail = UserDefaults.standard.value(forKey: Key_ClientWithoutCerdential) as? NSDictionary else { return "" }
        return ClientAccessDetail[forKey] as! String
    }
    class func removeClienDetailWithoutCerdential() {
        Default.removeObject(forKey: Key_ClientWithoutCerdential)
    }
    
    //    MARK:- ClientUserDetail Data in UserDefult
    class func saveClientUserDetail(_ Dicdata:NSDictionary) {
        Default.setValue(Dicdata, forKey: Key_ClientUserDetail)
        Default.synchronize()
    }
    class func getClienUserDetailKeyData(_ forKey: String) -> String{
        guard let ClienUserDetail = UserDefaults.standard.value(forKey: Key_ClientUserDetail) as? NSDictionary else { return "" }
        return ClienUserDetail[forKey] as! String
    }
    class func removeClientUserDetail() {
        Default.removeObject(forKey: Key_ClientUserDetail)
    }
    class func getClientUserDetail() -> NSDictionary? {
        return Default.value(forKey: Key_ClientUserDetail) as? NSDictionary
    }
    
    //    MARK:- Date Converted functions
    class func convertDateToMonthAndYear(strDate:Date) -> String{
        basic.dateFormate.dateFormat = "MMMM yyyy"
        //        basic.dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = basic.dateFormate.string(from:strDate)
        //        basic.dateFormate.dateFormat = "yyyy-MM-dd"
        //        let timeStamp = basic.dateFormate.string(from: date)
        return date
    }
    
    class func ConvertDateToMonth(StrDate:String) -> String {
        basic.dateFormate.dateFormat = "MMMM dd, yyyy"
        basic.dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = basic.dateFormate.date(from: StrDate)
        basic.dateFormate.dateFormat = "yyyy-MM-dd"
        let timeStamp = basic.dateFormate.string(from: date!)
        return timeStamp
    }
    
    class func ConvertDateToServerDateFormate(StrDate:String) -> String {
        basic.dateFormate.dateFormat = "MMMM dd, yyyy"
        basic.dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = basic.dateFormate.date(from: StrDate)
        basic.dateFormate.dateFormat = "yyyy-MM-dd"
        let timeStamp = basic.dateFormate.string(from: date!)
        return timeStamp
    }
    
    class func ConvertDateStringToDate(StrDate:String) -> Date {
        basic.dateFormate.dateFormat = "yyyy-MM-dd"
        //        basic.dateFormate.locale = Locale.current
        basic.dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = basic.dateFormate.date(from: StrDate)
        return date!
    }
    
    class func DateFormateConverter(strDate:String) -> String {
        let dateFormetter = DateFormatter()
        dateFormetter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) as Calendar!
        dateFormetter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        dateFormetter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormetter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormetter.date(from: strDate)
        print("date:=\(date!)")
        dateFormetter.dateFormat = "dd-MM-yyyy"
        let timeStamp = dateFormetter.string(from: date!)
        return timeStamp
    }
    
    deinit {
        //        stopNotifier()
        setLeftMenuSelected = nil
        IsFromScreen = nil
        storeBookingDetail = nil
    }
}

func SalonLog(_ logMessage: Any, functionName: String = #function ,file:String = #file,line:Int = #line) {
    print("\(((file as NSString).lastPathComponent as NSString).deletingPathExtension)-->\(functionName),Line:\(line) ==> \(logMessage)")
}


//MARK:- extern inline functions
func getDefaultDeviceToken() -> String {
    if Default.value(forKey: Key_DeviceToken) != nil {
        return Default.value(forKey: Key_DeviceToken) as! String
    }
    else {
        return "Not Found"
    }
    
}

//MARK:- Extension
extension UIColor {
    
    
    
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    func setTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: text!)
        if textAlignment == .center || textAlignment == .right {
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: attributedString.length-1))
        } else {
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        }
        attributedText = attributedString
    }
}

extension String {
    static func random(length: Int = 12) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    func containsIgnoringCaseLocation(Text:NSString, find:NSString) -> Int? {
        if Text.localizedCaseInsensitiveContains(find as String) {
            let range = Text.range(of: find as String)
            print("found swift")
            return range.location
        }
        else {
            return nil
        }
    }
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "<p>"       : "",
            "</p>"      : ""
        ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
            //                newStr.stringByReplacingOccurrencesOfString(name, withString: value)
        }
        print("newStr:=\(newStr)")
        return newStr
    }
    func validateEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

