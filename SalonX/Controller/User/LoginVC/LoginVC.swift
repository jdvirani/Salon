//
//  LoginVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/16/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet weak var txt_Password: UITextField!
    
    @IBOutlet weak var btn_Login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        btn_Login.layer.borderWidth = 1
        btn_Login.layer.borderColor = UIColor.lightGray.cgColor
        
//        btn_fb.readPermissions = ["public_profile","email","user_friends"]
       
    }
    
    
    
//    MARK:- Button Action
    @IBAction func btn_SignupAction(_ sender: UIButton) {
        
        let Signup = SignupVC(nibName:nil, bundle: nil)
        self.navigationController?.pushViewController(Signup, animated: true)
    }
    
    @IBAction func btn_LoginAction(_ sender: UIButton) {
        txt_Email.resignFirstResponder()
        txt_Password.resignFirstResponder()
        
        if !(txt_Email.text?.isEmpty)! && !(txt_Password.text?.isEmpty)!{
            
            BasicStuff.showLoader(self.view)
            let sendDict = NSMutableDictionary()
            sendDict.setValue(txt_Email.text, forKey: "email")
            sendDict.setValue(txt_Password.text!, forKey: "password")
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue("123", forKey: "device_token")
            sendDict.setValue(BasicStuff.basic.deviceType, forKey: "device_type")
            sendDict.setValue("", forKey: "register_id")
            
            SalonLog("Dictionary object ==>\(sendDict)")
            
            let manager = ServiceCall(URL: API_Login_Email)
            manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
            manager.setContentType(contentType: .multiPartForm)

            manager.POST(parameters: sendDict) { (success:Bool, responceObj:Any) in
                BasicStuff.dismissLoader()
                SalonLog("responce object ==>\(responceObj)")
                
                if success {
                    let Obj = responceObj as! NSDictionary

                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    if flag == 1 {
                        let getData = (Obj.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        BasicStuff.removeClienDetailWithoutCerdential()
                        getData.setValue("1", forKey: Key_IsLogin)
                        BasicStuff.saveClienDetailWithoutCerdential(getData)
                        let getScreen = BasicStuff.basic.IsFromScreen
                        if (getScreen?.isEmpty)! {
                            let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                            self.navigationController?.navigationBar.isHidden = false
                            self.navigationController?.pushViewController(Home, animated: true)
                        }
                        else {
                            let SalonId = BasicStuff.basic.storeBookingDetail.value(forKey: "salon_id") as! String
                            let SalonServiceId = BasicStuff.basic.storeBookingDetail.value(forKey: "service_id") as! String
                            let SalonType = BasicStuff.basic.storeBookingDetail.value(forKey: "salon_type") as! String
                            
                            if getScreen == "SalonListVC" {
                                
                                let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
                                Booking.salon_id = SalonId
                                Booking.service_id = SalonServiceId
                                Booking.salon_type = SalonType
                                self.navigationController?.pushViewController(Booking, animated: true)
                            }
                            else if getScreen == "SalonDetailVC" {
                                let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
                                Booking.salon_id = SalonId
                                Booking.service_id = SalonServiceId
                                Booking.salon_type = SalonType
                                self.navigationController?.pushViewController(Booking, animated: true)
                            }
                            else {
                                let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                                self.navigationController?.navigationBar.isHidden = false
                               self.navigationController?.pushViewController(Home, animated: true)
                            }
                        }
                    }
                    else {
                        BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    }
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                }
            }

        }
        else {
            if (txt_Email.text?.isEmpty)! {
                BasicStuff.showAlert(title: ALERT_TITLE, message: "Please enter email")
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: "Please enter password")
            }
            
        }
        
  /*      let leftViewController = LeftMenuVC(nibName: "LeftMenuVC", bundle: nil)
        let mainNavigation = UINavigationController(rootViewController: MainViewController1)
        leftViewController.mainViewController = mainNavigation
        
        let slideMenuController = SlideMenuController(mainViewController: mainNavigation, leftMenuViewController: leftViewController)
        */
    
//    let MainViewController1 = HomeVC(nibName: "HomeVC", bundle: nil)
//    self.navigationController?.navigationBar.isHidden = false
//    self.navigationController?.pushViewController(MainViewController1, animated: true)
    }
    
//    MARK:- Facebook Login Action
    @IBAction func btn_FBLoginAction(_ sender: UIButton) {
        
        let loginPermission = FBSDKLoginManager()
        loginPermission.logIn(withReadPermissions:["public_profile","email","user_friends"] , from: self) { (result, error) in
            
            if ((error) != nil) {
                print("error:=\(error?.localizedDescription)")
            }
            else if(result?.isCancelled)! {
                print("Login Cancelled")
            }
            else {
                print("Loogin Success")
                print("result:=\(result)")
                if (result?.token) != nil {
                    self.getFBResult()
                }
            }
        }
    }
    
    func getFBResult() {
        BasicStuff.showLoader(self.view)
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print("result:=\(result!)")
                    let getDic = result as! NSDictionary
                    let profileUrl = ((getDic.value(forKey: "picture") as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "url") as? String
                    self.facebookLoginWebService(FBid: getDic["id"] as? String, firstname: getDic["first_name"] as? String, lastname: getDic["last_name"] as? String, email: getDic["email"] as? String, profile_pic: profileUrl)
                }
                else {
                     BasicStuff.dismissLoader()
                     BasicStuff.showAlert(title: ALERT_TITLE, message: "Please login again")
                }
               
            })
        }
        else {
            BasicStuff.dismissLoader()
            BasicStuff.showAlert(title: ALERT_TITLE, message: "Please login again")
        }
    }
    func facebookLoginWebService (FBid:String?,firstname:String?,lastname:String?,email:String?,profile_pic:String?) {
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(FBid, forKey: "oauth_id")
        sendDict.setValue(firstname, forKey: "firstname")
        sendDict.setValue(lastname, forKey: "lastname")
        sendDict.setValue(email, forKey: "email")
        sendDict.setValue(profile_pic, forKey: "profile_pic")
        sendDict.setValue("facebook", forKey: "provider")
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue("123515", forKey: "device_token")
        sendDict.setValue("", forKey: "register_id")
        sendDict.setValue(BasicStuff.basic.deviceType, forKey: "device_type")
        
        print("sendDict:=\(sendDict)")
        
        let manager = ServiceCall(URL: API_Social_Login)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success:Bool, responceObj:Any) in
            BasicStuff.dismissLoader()
            SalonLog("responce object ==>\(responceObj)")
            if success {
                let Obj = responceObj as! NSDictionary
                
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                    let getData = (Obj.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    BasicStuff.removeClienDetailWithoutCerdential()
                    getData.setValue("1", forKey: Key_IsLogin)
                    BasicStuff.saveClienDetailWithoutCerdential(getData)
                    let getScreen = BasicStuff.basic.IsFromScreen
                    if (getScreen?.isEmpty)! {
                        let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                        self.navigationController?.navigationBar.isHidden = false
                        self.navigationController?.pushViewController(Home, animated: true)
                    }
                    else {
                        let SalonId = BasicStuff.basic.storeBookingDetail.value(forKey: "salon_id") as! String
                        let SalonServiceId = BasicStuff.basic.storeBookingDetail.value(forKey: "service_id") as! String
                        let SalonType = BasicStuff.basic.storeBookingDetail.value(forKey: "salon_type") as! String
                        
                        if getScreen == "SalonListVC" {
                            
                            let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
                            Booking.salon_id = SalonId
                            Booking.service_id = SalonServiceId
                            Booking.salon_type = SalonType
                            self.navigationController?.pushViewController(Booking, animated: true)
                        }
                        else if getScreen == "SalonDetailVC" {
                            let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
                            Booking.salon_id = SalonId
                            Booking.service_id = SalonServiceId
                            Booking.salon_type = SalonType
                            self.navigationController?.pushViewController(Booking, animated: true)
                        }
                        else {
                            let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                            self.navigationController?.navigationBar.isHidden = false
                            self.navigationController?.pushViewController(Home, animated: true)
                        }
                    }
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                }
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
        }
    }

    //    MARK:- TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    /*
     /
     / MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
