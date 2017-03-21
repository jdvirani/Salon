//
//  AddAppointmentViewController.swift
//  SalonX
//
//  Created by DK on 21/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class AddAppointmentViewController: UIViewController {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    // General
    @IBOutlet var viewAppointment: UIView!
    @IBOutlet var viewLastMinute: UIView!
    @IBOutlet var viewPersonal: UIView!
    
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnLastMinute: UIButton!
    
    @IBOutlet weak var lblHeaderInfo: UILabel!

    @IBOutlet var btnCornerStyle: [UIButton]!
    @IBOutlet  var viewCornerStyle: [UIView]!
    
    @IBOutlet weak var bottomOfMainView: NSLayoutConstraint!
    
    // Appointment
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var lblService: UILabel!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var imgClientPicture: UIImageView!
    @IBOutlet weak var txtClientName: UITextField!
    @IBOutlet weak var txtClientPhone: UITextField!
    @IBOutlet weak var txtClientEmail: UITextField!
    @IBOutlet weak var btnSMSCheckBox: UIButton!
    @IBOutlet weak var btnEmailCheckBox: UIButton!
    
    var searchString = ""
    
    var clientNameDD = DropDown()
    var clientListItems: [JSON] = [] {
        didSet {
            var clientName: [String] = []
            for item in clientListItems {
                clientName.append(item["user_name"].stringValue)
            }
            clientNameDD.dataSource = clientName
            clientNameDD.show()
            
            clientNameDD.selectionAction = { (index,item) in
                
                let clientDetail = self.clientListItems[index]
                self.setUserDetail(clientDetail: clientDetail)
            }
        }
    }
    
    var appointmentServiceDD = DropDown()
    var serviceItems: [JSON] = [] {
        didSet {
            var services: [String] = []
            
            for item in serviceItems {
                services.append(item["name"].stringValue)
            }
            appointmentServiceDD.dataSource = services
        }
    }
    
    var durationTag = 12 {
        didSet {
            lblDuration.text = "\(durationTag * 15) min"
        }
    }
    
    // Personal
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var lblPersonalDuration: UILabel!
    
    var personalDuration = 12 {
        didSet {
            if personalDuration == 1 {
                lblPersonalDuration.text = "15 min"
            } else if personalDuration == 2 {
                lblPersonalDuration.text = "30 min"
            } else if personalDuration == 3 {
                lblPersonalDuration.text = "45 min"
            }
        }
    }
    
    
    // Last Minute
    @IBOutlet weak var btnLastMinuteServiceDD: UIButton!
    @IBOutlet weak var lblServiceName: UILabel!
    
    @IBOutlet weak var btnLastMinuteCategoryDD: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblLastMinuteDuration: UILabel!
    @IBOutlet weak var txtNormalPrice: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtOfferPrice: UITextField!
    
    @IBOutlet weak var txtDiscription: UITextView!
    
    
    var lastMinteServiceDD = DropDown()
    var lastMinuteCategoryDD = DropDown()
    
    
    var lastMinuteServiceItems: [String] = ["item1","item2","item3"]
    var lastMinuteCategoryItems: [String] = ["item1","item2","item3"]
    
    var lastMinuteDuration = 3 {
        didSet {
            if lastMinuteDuration == 1 {
                lblLastMinuteDuration.text = "15 min"
            } else if lastMinuteDuration == 2 {
                lblLastMinuteDuration.text = "30 min"
            } else if lastMinuteDuration == 3 {
                lblLastMinuteDuration.text = "45 min"
            }
        }
    }
    
    var discount = 20 {
        didSet {
            txtDiscount.text = "\(discount) %"
        }
    }
    
    
    convenience init() {
        self.init(nibName: R.nib.addAppointmentVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedString(key: "addAppointment")
        viewAppointment.isHidden = false
        viewPersonal.isHidden = true
        viewLastMinute.isHidden = true
        
        setupBackButton()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(colorChanged), name: NSNotification.Name(rawValue: "colorChanged"), object: nil)
       
        
        //Appointment
        durationTag = 3
        
        //Personal
        personalDuration = 3
        
        //Last Minute
        lastMinteServiceDD.dataSource = lastMinuteServiceItems
        lastMinuteCategoryDD.dataSource = lastMinuteCategoryItems
        lastMinuteDuration = 3
        discount = 20
        
        txtClientName.delegate = self
        txtDiscount.delegate = self
        txtDiscount.keyboardType = .numberPad
        txtNormalPrice.keyboardType = .decimalPad
        txtOfferPrice.keyboardType = .decimalPad
        
        bottomOfMainView.constant = self.view.bounds.height - UIScreen.main.bounds.height + 20
        
       getServiceList()

    }
    
    //Setup UI
    func setupUI() {
        btnCornerStyle.forEach({ $0.layer.cornerRadius = $0.frame.height / 2
            $0.clipsToBounds = true
        })
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        
        viewCornerStyle.forEach({ $0.addCornerAndBorderStyle() })
        
        let artistName = NSAttributedString(string: "Bebe Veja", attributes: [ NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!, NSForegroundColorAttributeName: R.color.salonX.accent()])
        
        let precedingString = NSAttributedString(string: "Start at 17:00-17:45 Marti 27 Sept 2016 By ", attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!, NSForegroundColorAttributeName: R.color.salonX.headerBG()])
        
        let finalHeaderString = NSMutableAttributedString()
        finalHeaderString.append(precedingString)
        finalHeaderString.append(artistName)
        
        lblHeaderInfo.attributedText = finalHeaderString
        
        //Appointment
        txtPrice.addCornerAndBorderStyle()
        txtPrice.customizeTextfield()
        
        configDropdown(dropdown: clientNameDD, sender: txtClientName)
        configDropdown(dropdown: appointmentServiceDD, sender: btnService)
        
        btnSMSCheckBox.isSelected = true
        
        // Personal
        txtNote.addCornerAndBorderStyle()
        
        //Last Minute
        configDropdown(dropdown: lastMinteServiceDD, sender: btnLastMinuteServiceDD)
        configDropdown(dropdown: lastMinuteCategoryDD, sender: btnLastMinuteCategoryDD)
        [txtNormalPrice,txtOfferPrice].forEach({ $0?.customizeTextfield()
            $0?.addCornerAndBorderStyle()
        })
        txtDiscription.addCornerAndBorderStyle()
    }
    
    func configDropdown(dropdown: DropDown, sender: UIView) {
        dropdown.anchorView = sender
        dropdown.direction = .bottom
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = sender.frame.width
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
    }
    
    func darkBackground() {
        [btnAppointment,btnPersonal,btnLastMinute].forEach({ $0?.backgroundColor = R.color.salonX.fontDark() })
    }
    
    func colorChanged(notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        let color = dict["color"] as! UIColor
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        viewColor.backgroundColor = color
    }
    
    func setUserDetail(clientDetail: JSON) {
        
        if let url = URL(string: clientDetail["user_profile_pic"].stringValue) {
            imgClientPicture.sd_setImage(with: url, placeholderImage: R.image.placeholder__client(), options: .lowPriority)
        } else{
            imgClientPicture.image = R.image.placeholder__client()
        }
        
        txtClientName.text = clientDetail["user_name"].stringValue
        txtClientPhone.text = clientDetail["phone_no"].stringValue
        txtClientEmail.text = clientDetail["email_address"].stringValue
        
        view.endEditing(true)
    }
}

//MARK: - Network Helper
extension AddAppointmentViewController {
    
    func getServiceList() {
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
        ]
        
        GetServiceList().getServiceListRequest(param: param, completion: { (result) in
            BasicStuff.dismissLoader()
            if let json = result.value {
                if json[R.string.keys.flag()].stringValue == "1" {
                    
                    self.serviceItems = json["data"].arrayValue
                }
            }
        })
    }
    
}


//MARK: - Actions
extension AddAppointmentViewController {
    
    @IBAction func btnAppointmentTapped(_ sender: UIButton) {
        self.title = LocalizedString(key: "addAppointment")
        bottomOfMainView.constant = self.view.bounds.height - UIScreen.main.bounds.height + 20
        darkBackground()
        btnAppointment.backgroundColor = R.color.salonX.accent()
        viewAppointment.isHidden = false
        viewPersonal.isHidden = true
        viewLastMinute.isHidden = true
        
    }
    
    @IBAction func btnPersonalTapped(_ sender: UIButton) {
        self.title = LocalizedString(key: "personal")
        bottomOfMainView.constant = self.view.bounds.height - UIScreen.main.bounds.height + 20
        darkBackground()
        btnPersonal.backgroundColor = R.color.salonX.accent()
        viewPersonal.isHidden = false
        viewAppointment.isHidden = true
        viewLastMinute.isHidden = true
    }
    
    @IBAction func btnLastMinuteTapped(_ sender: UIButton) {
        self.title = LocalizedString(key: "lastMinute")
        bottomOfMainView.constant = self.view.bounds.height - UIScreen.main.bounds.height + 20
        darkBackground()
        btnLastMinute.backgroundColor = R.color.salonX.accent()
        viewLastMinute.isHidden = false
        viewAppointment.isHidden = true
        viewPersonal.isHidden = true
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Add Appointment
    @IBAction func serviceDDTapped(_ sender: UIButton) {
        appointmentServiceDD.show()
        
        appointmentServiceDD.selectionAction = { (index,item) in
            self.lblService.text = item
        }
    }
    
    @IBAction func btnIncrementTapped(_ sender: UIButton) {
        
        if sender.tag == 18 {
            
            //Appointment duration
            if durationTag < 13 {
                durationTag += 1
            }
        } else if sender.tag == 20 {
            // Personal Duration
            
            if personalDuration < 13 {
                personalDuration += 1
            }
            
        } else  if sender.tag == 22 {
            //Last minute duration
            
            
            if lastMinuteDuration < 13 {
                lastMinuteDuration += 1
            }
        } else if sender.tag == 24 {
            //Last Minute Discount
            if discount <= 100 {
                discount += 1
            }
        }
    }
    
    @IBAction func btnDecrementTapped(_ sender: UIButton) {
        
        
        if sender.tag == 17 {
            //Appointment duration
            
            if durationTag > 0 {
                durationTag -= 1
            }

        } else if sender.tag == 19 {
            // Personal Duration
            
            if personalDuration > 0 {
                personalDuration -= 1
            }
            
        } else  if sender.tag == 21 {
            //Last minute duration
            if lastMinuteDuration > 0 {
                lastMinuteDuration -= 1
            }
            
        } else if sender.tag == 23 {
            //Last Minute Discount
            if discount > 0 {
                discount -= 1
            }
        }
    }
    
    @IBAction func btnSMSCheckBox(_ sender: UIButton) {
        
        if btnSMSCheckBox.isSelected {
            btnSMSCheckBox.isSelected = false
        } else {
            btnSMSCheckBox.isSelected = true
        }
    }
    
    @IBAction func btnEmailCheckBox(_ sender: UIButton) {
        if btnEmailCheckBox.isSelected {
            btnEmailCheckBox.isSelected = false
        } else {
            btnEmailCheckBox.isSelected = true
            
        }
    }
    
    @IBAction func btnSaveAppointmentTapped(_ sender: UIButton) {
        view.endEditing(true)
    }
    

    //MARK: -  Personal Actions
    @IBAction func btnSavePersonalTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let vc = ColorPickerViewController()
        vc.modalPresentationStyle = .overCurrentContext
       

        self.present(vc, animated: true, completion: nil)
        
    }
    
    //MARK: - Last Minute Actions
    
    @IBAction func lastMinuteServiceDDTapped(_ sender: UIButton) {
        lastMinteServiceDD.show()
        
        lastMinteServiceDD.selectionAction = { (index,item) in
            self.lblServiceName.text = item
        }
    }
    
    @IBAction func lastMinuteCategoryDDTapped(_ sender: UIButton) {
        lastMinuteCategoryDD.show()
        
        lastMinuteCategoryDD.selectionAction = { (index,item) in
            self.lblCategory.text = item
        }
    }
    
    @IBAction func btnLaunchOfferTapped(_ sender: UIButton) {
        
    }
}

extension AddAppointmentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == txtClientName {
            
            print(textField.text)
            print(string)
            
            if string == "" {
                searchString = String(searchString.characters.dropLast())
            } else {
                searchString = textField.text! + string
            }
            
            let param = [R.string.keys.lang() : Language.shared.Lang,
                         R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                         R.string.keys.access_token() : getUserDetail( R.string.keys.access_token()),
                         "keyword" : searchString]
            
            if Rechability.isConnectedToNetwork() {
                
                SearchClientService().searchClientResquest(param: param, completion: { (result) in
                    if let json = result.value {
                        if json[R.string.keys.flag()].stringValue == "1" {
                            self.clientListItems = json["data"].arrayValue
                        }
                    }
                })
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDiscount {
            txtDiscount.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDiscount {
            if !(txtDiscount.text?.isEmpty)! {
                discount = Int(txtDiscount.text!)!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
