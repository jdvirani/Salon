//
//  ViewController.swift
//  SalonX
//
//  Created by DK on 09/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFBLogin: UIButton!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var lblSignUpAs: UILabel!
    @IBOutlet weak var btnBeautyProf: UIButton!
    
    var salonListVC: SalonListVC!
    var salonDetailVC:SalonDetailVC!
    
    
    //Load XIB
    convenience init() {
        self.init(nibName: R.nib.loginVC.name, bundle: nil)
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //Setup UI
    func setupUI() {
        btnLogin.borderWidth = 2.0
        btnLogin.borderColor = R.color.salonX.seperator()
        btnFBLogin.titleLabel?.font = UIFont.fontAwesome(ofSize: 15)
        
        localizeUI()
    }
    
    func localizeUI() {
        btnFBLogin.setTitle("\(String.fontAwesomeIcon(name: .facebook))    Continue with Facebook", for: .normal)
        btnLogin.setTitle(LocalizedString(key: "login"), for: .normal)
        btnSignup.setTitle(LocalizedString(key: "signUp"), for: .normal)
        btnHelp.setTitle(LocalizedString(key: "help"), for: .normal)
        lblDontHaveAccount.text = LocalizedString(key: "dontHaveAccount")
        lblSignUpAs.text = LocalizedString(key: "signUpAs")
        btnBeautyProf.setTitle(LocalizedString(key: "beatyProfessional"), for: .normal)
        txtEmail.placeholder = LocalizedString(key: "email")
        txtPassword.placeholder = LocalizedString(key: "password")
    }
    
    func validateUserInput() -> Bool {
        
        var errorMessage = ""
        
        errorMessage += txtEmail.text!.trimmed().validateEmail()
        
        errorMessage += txtPassword.text!.trimmed().validatePassword()
        
        if errorMessage.length > 0 {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: errorMessage)
        }
        
        return errorMessage.length == 0
        
    }
}

//MARK: - Network Helper
extension LoginViewController {
    
    func processLoginResponse(data: Result<JSON>) {
        
        print(data.value)
        
        if let json = data.value {
            print(json)
            
            if json["flag"].stringValue == "1" {
                
                let data = json["data"]
                
                // 1 for Salon and 0 for Client
                if json["access_flag"].stringValue == "1" {
                    
                    //Jaydeep Redirect to Salon.
                    let accessToken = data["access_token"].stringValue
                    UserDefaults.standard.setValue(accessToken, forKey: R.string.keys.access_token())
                    
                    guard let rawData = try? data.rawData() else { return }
                    UserDefaults.standard.setValue(rawData, forKey: R.string.keys.userDetail())
                    
                    if data["salon_type"].stringValue == "individual" {
                        UserDefaults.standard.set(true, forKey: "isIndividual")
                    } else {
                        UserDefaults.standard.set(false, forKey: "isIndividual")
                    }
                    
                    
                    if data["is_complete_profile"].stringValue == "0" {
                        if let screenNumber = data["remain_data"].string {
                            
                            self.navigationController?.navigationBar.isHidden = false
                            if screenNumber == "1" {
                                let vc = EditSalonDetailViewController()
                                vc.pushType = .signup
                                navigationController?.pushViewController(vc, animated: true)
                                
                            } else if screenNumber == "2" {
                                
                                let vc = EditExtraDetailViewController()
                                vc.pushType = .signup
                                navigationController?.pushViewController(vc, animated: true)
                            } else if screenNumber == "3" {
                                
                                let vc = ManagePicturesViewController()
                                vc.pushType = .signup
                                navigationController?.pushViewController(vc, animated: true)
                                
                            } else if screenNumber == "4" {
                                
                                let vc = ManageServiceViewController()
                                vc.pushType = .signup
                                navigationController?.pushViewController(vc, animated: true)
                                
                            } else if screenNumber == "5" {
                                
                                let vc = ManageEmployeeViewController()
                                vc.pushType = .signup
                                navigationController?.pushViewController(vc, animated: true)
                                
                            } else if screenNumber == "6" {
                                let vc = ManageProgramViewController()
                                vc.pushType = .signup
                                navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    } else if data["is_complete_profile"].stringValue == "1" {
                        
                        UserDefaults.standard.set(true, forKey:R.string.keys.isUserSignIn())
                        
                        appDelegate.configureWindowAndMakeVisible(rootVC: SalonMainTabBarController())
                    }
                    
                } else {
                    let tempData = data.dictionaryObject
                    print(tempData)
                    
                    let Obj = tempData! as NSDictionary
                    //MARK: - Redirect to User Hitesh
                    let getData = Obj.mutableCopy() as! NSMutableDictionary
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
                            
                            salonListVC.dismissLogin()
                            
                        }
                        else if getScreen == "SalonDetailVC" {
                            salonDetailVC.dismissLogin()
                            
                        }
                        else {
                            let slideController = appDelegate.setSideMenu()
                            self.navigationController?.navigationBar.isHidden = true
                            appDelegate.configureWindowAndMakeVisible(rootVC: slideController)
                        }
                    }
                }
            } else if json["flag"].stringValue == "0" {
                BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json["msg"].stringValue)
            }
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "somethingWentWrong"))
        }
    }
}

//MARK: - Actions
extension LoginViewController {
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if validateUserInput() {
            if Rechability.isConnectedToNetwork() {
                let param = [R.string.keys.email() : txtEmail.text!,
                             R.string.keys.password() : txtPassword.text!,
                             R.string.keys.lang() : Language.shared.Lang,
                             R.string.keys.device_token() : "987654321645655",
                             R.string.keys.register_id() : "",
                             R.string.keys.device_type() : "1"]
                
                print(param)
                
                BasicStuff.showLoader(self.view)
                
                LoginWebServices().loginRequest(param: param) { (result) in
                    
                    BasicStuff.dismissLoader()
                    
                    self.processLoginResponse(data: result)
                    
                }
            } else {
                BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
            }
        }
    }
    
    @IBAction func btnSignUpTapppd(_ sender: UIButton) {
        let Signup = SignupVC(nibName:nil, bundle: nil)
        let getScreen = BasicStuff.basic.IsFromScreen
        if getScreen == "SalonListVC" {
            Signup.SalonListvc = salonListVC
        }
        if getScreen == "SalonDetailVC" {
            Signup.SalonDetailvc = salonDetailVC
        }
        self.navigationController?.pushViewController(Signup, animated: true)
    }
    
    @IBAction func btnHelpTapppd(_ sender: UIButton) {
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: false)
    }
    
    @IBAction func btnSignupBeautyProfTapppd(_ sender: UIButton) {
        
        navigationController?.pushViewController(SalonSignupViewController(), animated: true)
    }
    
    @IBAction func btnFBLoginTapped(_ sender: UIButton) {
        if Rechability.isConnectedToNetwork() {
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
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
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
                        let slideController = appDelegate.setSideMenu()
                        self.navigationController?.navigationBar.isHidden = true
                        appDelegate.configureWindowAndMakeVisible(rootVC: slideController)
                    }
                    else {
                        if getScreen == "SalonListVC" {
                            self.salonListVC.dismissLogin()
                        }
                        else if getScreen == "SalonDetailVC" {
                            self.salonDetailVC.dismissLogin()
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

