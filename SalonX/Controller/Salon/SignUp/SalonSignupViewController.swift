//
//  SalonSignupViewController.swift
//  SalonX
//
//  Created by DK on 10/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import CoreLocation
import Alamofire

class SalonSignupViewController: UIViewController {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtBussinessType: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblSignUpAs: UILabel!
    @IBOutlet weak var btnUser: UIButton!
    
    let bussinessTypeItem = ["Individual","Business"]
    var bussinessTypeDD = DropDown()
    
    var userLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    //Load XIB
    convenience init() {
        self.init(nibName: R.nib.salonSignupVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bussinessTypeDD.dataSource = bussinessTypeItem
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        
        txtBussinessType.delegate = self
        txtCity.delegate = self
        txtPhone.delegate = self
        
        configDropdown(dropdown: bussinessTypeDD, sender: txtBussinessType)
        txtName.customizeTextfield()
        txtEmail.customizeTextfield()
        txtBussinessType.customizeTextfield()
        txtCity.customizeTextfield()
        txtPhone.customizeTextfield()
        txtPassword.customizeTextfield()
        txtConfirmPassword.customizeTextfield()
        
        btnRegister.borderWidth = 2.0
        btnRegister.borderColor = R.color.salonX.seperator()
    }
    
    func localizeUI() {
        
        txtName.placeholder = LocalizedString(key: "name")
        txtEmail.placeholder = LocalizedString(key: "email")
        txtBussinessType.placeholder = LocalizedString(key: "businessType")
        txtCity.placeholder = LocalizedString(key: "city")
        txtPhone.placeholder = LocalizedString(key: "phone")
        txtPassword.placeholder = LocalizedString(key: "password")
        txtConfirmPassword.placeholder = LocalizedString(key: "confirmPasword")
        btnRegister.setTitle(LocalizedString(key: "register"), for: .normal)
        lblAlreadyAccount.text = LocalizedString(key: "alreadyHaveAccount")
        btnLogin.setTitle(LocalizedString(key: "login"), for: .normal)
         lblSignUpAs.text = LocalizedString(key: "signUpAs")
        btnUser.setTitle(LocalizedString(key: "user"), for: .normal)
        
    }
    
    func configDropdown(dropdown: DropDown, sender: UIView) {
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = sender.frame.width
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
    }
    
    func validateUserInput() -> Bool {
        
        var errorMessage = ""
        
        if !txtName.text!.trimmed().validateFirstName() {
            errorMessage += LocalizedString(key: "nameRequired")
        }
        
        if !txtEmail.text!.trimmed().validateEmail() {
            errorMessage += LocalizedString(key: "invalidEmail")
        }
        
        if (txtCity.text?.trimmed().isEmpty)! {
            errorMessage += "City required."
        }
        
        if (txtPhone.text?.trimmed().isEmpty)! {
            errorMessage += "Phone number required."
        }
        
        if txtBussinessType.text!.isEmpty {
            errorMessage += "Select Bussuiness type"
        }
        
        errorMessage += (txtConfirmPassword.text?.trimmed().validatePassword())!
        
        errorMessage += txtPassword.text!.trimmed().validatePassword()
        
        if txtPassword.text?.trimmed() != txtConfirmPassword.text?.trimmed() {
            errorMessage += "Confirm password doesn't match."
        }
        
        if errorMessage.length > 0 {
            BasicStuff.showAlert(title: "SalonX", message: errorMessage)
        }
        
        return errorMessage.length == 0
        
    }
}

extension SalonSignupViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtBussinessType {
            bussinessTypeDD.show()
            bussinessTypeDD.selectionAction = { (index, item) in
                self.txtBussinessType.text = item
            }
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCity {
            guard let text = textField.text else {
                return true
            }
            
            return UserInputValidator.nameOnly(text: text, range: range, replacementString: string, maxLength: 100)
        }
        
        if textField == txtPhone {
            guard let text = textField.text else {
                return true
            }
            
            return UserInputValidator.digitsOnly(text: text, range: range, replacementString: string, maxLength: 10)
        }
        
        return true
    }
    
}

extension SalonSignupViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
            print(location)
            locationManager.stopUpdatingLocation()
        }
    }
}

//MARK: - Newtwork Helper

extension SalonSignupViewController {
    
    func processSignupResponse(data: Result<JSON>) {
        if let json = data.value {
            if json["flag"].stringValue == "1" {
//                let data = json["data"]
//                let accessToken = data["access_token"].stringValue
//                
//                guard let rawData = try? data.rawData() else { return }
//                
//                UserDefaults.standard.setValue(accessToken, forKey: R.string.keys.access_token())
//                UserDefaults.standard.setValue(rawData, forKey: R.string.keys.userDetail())
//                
//                let vc = EditSalonDetailViewController()
//                vc.pushType = .signup
//                let navVC = UINavigationController(rootViewController: vc )
//                appDelegate.configureWindowAndMakeVisible(rootVC: navVC)
                
                _ = navigationController?.popViewController(animated: false)
            }
        }
    }
}

//MARK: - Actions
extension SalonSignupViewController {
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validateUserInput() {
             if Rechability.isConnectedToNetwork() {
                var param = [R.string.keys.firstname() : txtName.text!,
                             R.string.keys.email() : txtEmail.text!,
                             R.string.keys.password() : txtPassword.text!,
                             R.string.keys.mobile() : txtPhone.text!,
                             R.string.keys.city() : txtCity.text!,
                             R.string.keys.business_type() : txtBussinessType.text!.lowercased(),
                             R.string.keys.lang() : Language.shared.Lang,
                             R.string.keys.device_token() : "",
                             R.string.keys.register_id() : "" ,
                             R.string.keys.device_type() : "1"]

                SalonSignupWebService().signUpRequest(param: param, completion: { (result) in
                    
                    self.processSignupResponse(data: result)
                    
                })
            } else {
                BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
            }
        }
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignupUserTapped(_ sender: UIButton) {
        let Signup = SignupVC(nibName:nil, bundle: nil)
        self.navigationController?.pushViewController(Signup, animated: true)
    }
    
}
