//
//  SignupVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/16/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class SignupVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Phone: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_ConformPassword: UITextField!
    
    @IBOutlet weak var lbl_StaticAlreadyHaveanAccount: UILabel!
    
    @IBOutlet weak var lbl_StaticLoginin: UILabel!
    
    @IBOutlet weak var lbl_Static_Or: UILabel!
    
    @IBOutlet weak var lbl_Static_BeautyProfessional: UILabel!
    @IBOutlet weak var lbl_Static_SignUpas: UILabel!
    @IBOutlet weak var btn_Facebook: UIButton!
    @IBOutlet weak var btn_Register: UIButton!
    
    var SalonListvc:SalonListVC!
    var SalonDetailvc:SalonDetailVC!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
        btn_Register.layer.borderWidth = 1
        btn_Register.layer.borderColor = UIColor.lightGray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalizedStaticText()
    }
    
//    MARK:- Custom Function
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
        sendDict.setValue("123", forKey: "device_token")
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
                        if getScreen == "SalonListVC" {
                            
                            self.SalonListvc.dismissLogin()
                            
                        }
                        else if getScreen == "SalonDetailVC" {
                            self.SalonDetailvc.dismissLogin()
                            
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
    func setLocalizedStaticText() {
        
        lbl_Static_Or.text = LocalizedString(key: "lbl_Register_Or")
        lbl_StaticLoginin.text = LocalizedString(key: "lbl_Register_LoginIn")
        lbl_StaticAlreadyHaveanAccount.text = LocalizedString(key: "lbl_Register_AleradyHaveAccount")
        lbl_Static_SignUpas.text = LocalizedString(key: "lbl_Register_Signupas")
        lbl_Static_BeautyProfessional.text = LocalizedString(key: "lbl_Register_BeautyProfessional")
        
        txt_FirstName.placeholder = LocalizedString(key: "txtPlace_Register_FirstName")
        txt_LastName.placeholder = LocalizedString(key: "txtPlace_Register_LastName")
        txt_Email.placeholder = LocalizedString(key: "txtPlace_Register_Email")
        txt_Phone.placeholder = LocalizedString(key: "txtPlace_Register_Phone")
        txt_Password.placeholder = LocalizedString(key: "txtPlace_Register_Password")
        txt_ConformPassword.placeholder = LocalizedString(key: "txtPlace_Register_ConfirmPassword")
        
        btn_Register.setTitle(LocalizedString(key: "btn_Register"), for: .normal)
        btn_Facebook.setTitle(LocalizedString(key: "btn_Register_Facebook"), for: .normal)
    }
    //MARK:- Check Validation
    func checkValidation() -> Bool {
                
        if txt_FirstName.text == nil || txt_FirstName.text == "" {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Enterfirstname"))
        }
        if txt_LastName.text == nil || txt_LastName.text == "" {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Enterlastname"))
        }
        else if txt_Email.text == nil || txt_Email.text == "" {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Enteremail"))
        }
        else if !(txt_Email.text?.validateEmail())! {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Entervalidemail"))
        }
        else if txt_Phone.text == nil || txt_Phone.text == "" {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Enterphone"))
        }
        else if txt_Password.text == nil || txt_Password.text == "" {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Enterpassword"))
        }
        else if txt_ConformPassword.text == nil || txt_ConformPassword.text == ""  {
            BasicStuff.showAlert(title: ALERT_TITLE, message:LocalizedString(key: "msg_Enterconfirmpassword"))
        }
        else if txt_Password.text != txt_ConformPassword.text {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Notmatchconfirmpassword"))
        }
        else if (txt_Password.text?.characters.count)! < 6 {
            BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "msg_Minimumpasswordlenght"))
        }
        else {
            txt_FirstName.resignFirstResponder()
            txt_LastName.resignFirstResponder()
            txt_Email.resignFirstResponder()
            txt_Phone.resignFirstResponder()
            txt_Password.resignFirstResponder()
            txt_ConformPassword.resignFirstResponder()
            return true
        }
        
        return false
    }
    
//    MARK:- TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txt_Phone == textField{
            if range.location > 10 {
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
//    MARK:- Buttton Action
    @IBAction func btn_LoginAction(_ sender: UIButton) {
       _ = self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btn_RegisterAction(_ sender: UIButton) {
        
        if checkValidation() {
            BasicStuff.showLoader(self.view)
            let sendDict = NSMutableDictionary()
            sendDict.setValue(txt_FirstName.text, forKey: "firstname")
            sendDict.setValue(txt_LastName.text, forKey: "lastname")
            sendDict.setValue(txt_Email.text, forKey: "email")
            sendDict.setValue(txt_Password.text!, forKey: "password")
            sendDict.setValue(txt_Phone.text!, forKey: "mobile")
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(BasicStuff.basic.deviceToken, forKey: "device_token")
            sendDict.setValue(BasicStuff.basic.deviceType, forKey: "device_type")
            sendDict.setValue("", forKey: "register_id")
            
            SalonLog("Dictionary object ==>\(sendDict)")
            
            let manager = ServiceCall(URL:API_Registration)
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
                            let slideController = appDelegate.setSideMenu()
                            self.navigationController?.navigationBar.isHidden = true
                            appDelegate.configureWindowAndMakeVisible(rootVC: slideController)
                        }
                        else {
                            
                            if getScreen == "SalonListVC" {
                                
                                self.SalonListvc.dismissLogin()

                            }
                            else if getScreen == "SalonDetailVC" {
                                self.SalonDetailvc.dismissLogin()
                                
                            }
                            else {
                                let slideController = appDelegate.setSideMenu()
                                self.navigationController?.navigationBar.isHidden = true
                                appDelegate.configureWindowAndMakeVisible(rootVC: slideController)
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
    }
    
    
    @IBAction func btn_FaceBookSignupAction(_ sender: UIButton) {
        
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
    
    
    @IBAction func btn_SignupAsBeautyProfessionalAction(_ sender: UIButton) {
        
        navigationController?.pushViewController(R.storyboard.signup.signupVC()!, animated: false)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
