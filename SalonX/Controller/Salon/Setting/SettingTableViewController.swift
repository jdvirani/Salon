//
//  SettingTableViewController.swift
//  SalonX
//
//  Created by DK on 24/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedString(key: "setting")
        
        setupBackButton()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                
                let TermCondition = TermsAndConditionVC(nibName: "TermsAndConditionVC", bundle: nil)
                TermCondition.isFromSalon = true
                TermCondition.NavigationTitle = LocalizedString(key: "lbl_TermsAndConditionsHeader")
                navigationController?.pushViewController(TermCondition, animated: true)
                
                print("Termis")
            } else {
                let TermCondition = TermsAndConditionVC(nibName: "TermsAndConditionVC", bundle: nil)
                TermCondition.isFromSalon = true
                TermCondition.NavigationTitle = LocalizedString(key: "lbl_PrivacyPolicyHeader")
                navigationController?.pushViewController(TermCondition, animated: true)
                //Redirect to Privacy Policy
                print("Privacy")
            }
        } else {
            if indexPath.row == 0 {
                let contact = Contactus(nibName: "Contactus", bundle: nil)
                contact.isFromSalon = true
                navigationController?.pushViewController(contact, animated: true)
            } else if indexPath.row == 1 {
                // Redirect to Blog
            } else if indexPath.row == 2 {
                // Redirect to help
            }else if indexPath.row == 3 {
                // Redirect to Login & Password
            }else if indexPath.row == 4 {
                //Logout
                
                
                
                let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "areYouSureToLogout"), preferredStyle: .alert)
                let okAction = UIAlertAction(title: LocalizedString(key: "ok"), style: .default, handler: { (action) in
                    
                    let param = [R.string.keys.lang(): Language.shared.Lang,
                                 "user_id" : getUserDetail(R.string.keys.salon_id()),
                                 R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                                 "device_token" : "987654321645655",
                                 "user_type" : "1"]
                    if Rechability.isConnectedToNetwork() {
                        BasicStuff.showLoader(self.view)
                        LogoutService().logoutRequest(param: param, completion: { (result) in
                            print(result.value)
                            BasicStuff.dismissLoader()
                            if let json = result.value {
                                if json[R.string.keys.flag()].stringValue == "1" {
                                    
                                    [R.string.keys.access_token(), R.string.keys.userDetail(), "isIndividual",R.string.keys.isUserSignIn()].forEach( { UserDefaults.standard.removeObject(forKey: $0 ) })
                                    
                                    let vc = UINavigationController(rootViewController: LoginViewController())
                                    appDelegate.configureWindowAndMakeVisible(rootVC: vc)
                                } else if json[R.string.keys.flag()].stringValue == "0" {
                                    BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json["msg"].stringValue)
                                }
                            }
                        })
                    } else {
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
                    }
                })
                
                let cancelAction = UIAlertAction(title: LocalizedString(key: "cancel"), style: .cancel, handler: nil)
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
                
            }
        }
    }
}
