//
//  AddClientViewController.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class AddClientViewController: UIViewController, TimePickerDelegate {
    
    var isEditMode = false
    var clientDetail: JSON?
    var clientDetailChangedDelgate: ClientDetailChangedDelgate!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var imgClientPicture: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtType: UITextField!
    
    @IBOutlet var btnGender: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewBirthdate: UIView!
    @IBOutlet weak var txtBirthdate: UITextField!
    
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    var genderDropDown = DropDown()
    
    var selectedGender: String?
    
    var genderItems = ["Male", "Female"]
    
    convenience init() {
        self.init(nibName: R.nib.addClientVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtBirthdate.delegate = self
        
        setupUI()
        
        configDropdown(dropdown: genderDropDown, sender: btnGender)
        
        if isEditMode {
            if clientDetail != nil {
                
                if let url = URL(string: clientDetail!["user_profile_pic"].stringValue) {
                    imgClientPicture.sd_setImage(with: url, placeholderImage: R.image.placeholder__client(), options: .lowPriority)
                } else {
                    imgClientPicture.image = R.image.placeholder__client()
                }
                
                txtFirstName.text = clientDetail!["first_name"].stringValue
                txtLastName.text = clientDetail!["last_name"].stringValue
                txtType.text = clientDetail!["type"].stringValue.capitalized
                lblGender.text = clientDetail!["gender"].stringValue.capitalized
                selectedGender = clientDetail!["gender"].stringValue
                lblGender.textColor = UIColor.black
                txtPhone.text = clientDetail!["phone_no"].stringValue
                txtEmail.text = clientDetail!["email_address"].stringValue
                txtBirthdate.text = clientDetail!["dob"].stringValue
                txtNote.text = clientDetail!["description"].stringValue
                txtNote.textColor = UIColor.black
                btnAdd.setTitle(LocalizedString(key: "save"), for: .normal)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        setupBackButton()
        
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        txtNote.delegate = self
        
        txtFirstName.customizeTextfield()
        txtLastName.customizeTextfield()
        txtType.customizeTextfield()
        txtPhone.customizeTextfield()
        txtEmail.customizeTextfield()
        txtBirthdate.customizeTextfield()
        
        txtFirstName.addCornerAndBorderStyle()
        txtLastName.addCornerAndBorderStyle()
        txtType.addCornerAndBorderStyle()
        viewGender.addCornerAndBorderStyle()
        viewPhone.addCornerAndBorderStyle()
        viewEmail.addCornerAndBorderStyle()
        viewBirthdate.addCornerAndBorderStyle()
        viewNote.addCornerAndBorderStyle()
        
        txtPhone.keyboardType = .numberPad
    
        genderDropDown.dataSource = genderItems
        localizeUI()
    }
    
    func localizeUI() {
        
        self.title = LocalizedString(key: "addClient")
        txtFirstName.placeholder = LocalizedString(key: "firstName")
        txtLastName.placeholder = LocalizedString(key: "lastName")
        txtType.placeholder = LocalizedString(key: "type")
        txtPhone.placeholder = LocalizedString(key: "phone")
        txtEmail.placeholder = LocalizedString(key: "email")
        txtBirthdate.placeholder = LocalizedString(key: "birthdate")
        txtNote.text = LocalizedString(key: "note")
        btnAdd.setTitle(LocalizedString(key: "add"), for: .normal)
        btnCancel.setTitle(LocalizedString(key: "cancel"), for: .normal)
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
    
    func didSelectTime(time: String?) {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        txtBirthdate.text = time
    }
    
    func validateInput() -> Bool{
        
        var errorMessage = ""
        
        if !isEditMode {
            if selectedImage == nil {
                errorMessage += LocalizedString(key: "pleaseChooseImage")
            }
        }

        if txtFirstName.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterFirstName")
        } else if !txtFirstName.text!.trimmed().validateFirstName() {
            errorMessage += LocalizedString(key: "pleaseEnterValidName")
        }
        
        if txtLastName.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterLastName")
        } else if !txtLastName.text!.trimmed().validateFirstName() {
            errorMessage += LocalizedString(key: "pleaseEnterValidName")
        }
        
        if txtType.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseSelectType")
        }
        
        if selectedGender == nil {
            errorMessage += LocalizedString(key: "pleaseSelectGender")
        }
        
        if txtPhone.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterPhone")
        }
        
        if txtEmail.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterEmail")
        } else if !txtEmail.text!.trimmed().validateEmail() {
            errorMessage += LocalizedString(key: "pleaseEnterValidEmail")
        }
        
        if txtBirthdate.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseSelectBirthdate")
        }
        
        if txtNote.text.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterNotes")
        }
        
        if errorMessage.length > 0 {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: errorMessage)
        }
        
        return errorMessage.length == 0
        
    }
    
}

//MARK: - Actions
extension AddClientViewController {
    
    @IBAction func btnSelectImageTapped(_ sender: UIButton) {
        openImagePicker()
    }
    
    @IBAction func btnGenderTapped(_ sender: UIButton) {
        
        genderDropDown.show()
        
        genderDropDown.selectionAction = { (index, item) in
            print(item)
            self.lblGender.textColor = UIColor.black
            self.lblGender.text = item
            self.selectedGender = item.lowercased()
        }
    }
    
    @IBAction func btnAddClient(_ sender: UIButton) {
        
        if isEditMode {
            let userID = clientDetail!["user_id"].stringValue
            saveClientDetail(userID: userID)
        } else {
            saveClientDetail(userID: "0")
        }
        
    }
    
    @IBAction func btbCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Network Helper
extension AddClientViewController {
    
    func saveClientDetail(userID: String) {
        if validateInput() {
            
            let param: [String : String] = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                                            R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                                            R.string.keys.lang() : Language.shared.Lang,
                                            "flag_view" : "1",
                                            "user_id" : "\(userID)",
                                            "first_name" : txtFirstName.text!,
                                            "last_name" : txtLastName.text!,
                                            "gender" : selectedGender!,
                                            "phone_no" : txtPhone.text!,
                                            "email" : txtEmail.text!,
                                            "birthdate" : txtBirthdate.text!,
                                            "type" : txtType.text!,
                                            "note" : txtNote.text,
                                            ]
            
            if Rechability.isConnectedToNetwork() {
                print(param)
                let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.clientURL()
                
                let manager = ServiceCall(URL: kURL)
                manager.setContentType(contentType: .multiPartForm)
                manager.setAuthorization(username: R.string.keys.authUsername(), password: R.string.keys.authPassword())
                BasicStuff.showLoader(self.view)
                
                manager.POST(params: param as NSDictionary, appendBodyWithBlock: { (multiPartData) in
                    if let imageData = UIImageJPEGRepresentation(selectedImage!, 0.6) {
                        multiPartData.appendData(data: imageData, Key: "user_picture", fileName: "file.png")
                    }
                }) { (status, response) in
                    print(response)
                    BasicStuff.dismissLoader()
                    if status {
                        if let json = response as? NSDictionary {
                            if json["flag"] as! NSNumber == 1 {
                                    
                                    let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: json["msg"] as? String, preferredStyle: .alert)
                                    
                                    alertController.addAction(UIAlertAction(title: LocalizedString(key: "Ok"), style: .cancel, handler: { (action) in
                                        if self.isEditMode {
                                        _ = self.navigationController?.popViewController(animated: false)
                                        self.clientDetailChangedDelgate.isDetailChanged(status: true)
                                        }
                                    }))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
            } else {
                BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
            }
        }
    }
    
}

extension AddClientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePicker() {
        let imageOptionController = UIAlertController(title: "SalonX", message: "Please choose the image.", preferredStyle: .actionSheet)
        imageOptionController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.imagePicker.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.tabBar.isHidden = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }))
        
        imageOptionController.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.imagePicker.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.tabBar.isHidden = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }))
        
        imageOptionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        tabBarController?.present(imageOptionController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgClientPicture.image = image
        selectedImage = image
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Textfield Methods
extension AddClientViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtBirthdate {
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            let vc = TimePickerViewController()
            vc.controlType = .datePicker
            vc.timePickerDelegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
}

//MARK: - Textview Methods
extension AddClientViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LocalizedString(key: "note") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LocalizedString(key: "note")
            textView.textColor = R.color.salonX.headerBG()
        }
    }
}
