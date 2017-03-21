
//  ChangePasswordViewController.swift
//  SalonX
//
//  Created by DK on 09/03/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    convenience init() {
        self.init(nibName: R.nib.forgotPasswordVC.name, bundle: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }

    func setupUI() {
        
        navigationController?.navigationBar.isHidden = true
        btnSend.borderWidth = 2.0
        btnSend.borderColor = R.color.salonX.seperator()
        txtEmail.customizeTextfield()
        
        localizeUI()
    }
    
    func localizeUI() {
        lblHeader.text = LocalizedString(key: "forgotPassword")
    
    }
    
    @IBAction func btnSendTapped(_ sender: UIButton) {
        
        var errorMessage = ""
        
        errorMessage += txtEmail.text!.trimmed().validateEmail()
        
        if errorMessage.length > 0 {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: errorMessage)
        }
        
        if errorMessage.length == 0 {
            //TODO : - Implement Webservice
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
}
