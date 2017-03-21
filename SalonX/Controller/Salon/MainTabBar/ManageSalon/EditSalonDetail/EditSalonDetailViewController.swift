//
//  EditSalonDetailViewController.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import MapKit

class EditSalonDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var viewCorner: [UIView]!
    
    @IBOutlet weak var lblGeneralHeader: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBussinessURL: UITextField!
    @IBOutlet weak var lblPrecedURL: UILabel!
    @IBOutlet weak var btnProfessionDD: UIButton!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var lblSalonAddressHeader: UILabel!
    @IBOutlet weak var btnCountryDD: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtSalonName: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblSocialMedialHeader: UILabel!
    @IBOutlet weak var btnWebLink: UIButton!
    @IBOutlet weak var btnWhatsapp: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnYoutube: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnGooglePlus: UIButton!
    @IBOutlet weak var btnPinterest: UIButton!
    @IBOutlet weak var txtSocialLinks: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var selectedCountry: String?
    var selectedProfession: String?
    
    var pushType: PushType = .login
    
    var professionItem: [JSON] = []
    var professionDD = DropDown()
    
    var socialProfile: [String : String] = [:]
    
    var countryList: [Country] = [] {
        didSet {
            var list: [String] = []
            for i in countryList {
                list.append(i.county_name)
            }
            countryDD.dataSource = list
        }
    }
    
    var countryDD = DropDown()
    
    var userLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    var selectedButton: UIButton! {
        didSet {
            [btnWebLink,btnWhatsapp,btnFacebook,btnInstagram,btnYoutube,btnTwitter,btnGooglePlus,btnPinterest].forEach({ $0?.borderColor = .clear
                $0?.titleLabel?.font = UIFont.fontAwesome(ofSize: 12.0) })
            selectedButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 14.0)
            selectedButton.borderWidth = 1.0
            selectedButton.borderColor = R.color.salonX.headerBG()
            txtSocialLinks.text = ""
            for (k,v) in socialProfile {
                if k == "\(selectedButton.tag)" {
                    txtSocialLinks.text = v
                }
            }
        }
    }
    
    convenience init() {
        self.init(nibName: R.nib.editSalonDetailVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        setupUI()
        print(pushType)
        
        navigationController?.navigationBar.isHidden = false
        
        if pushType == .login {
            setupBackButton()
            btnNext.isHidden = true
        } else {
            self.navigationItem.hidesBackButton = true
            btnSave.isHidden = true
        }
        
        configDropdown(dropdown: professionDD, sender: btnProfessionDD)
        
        configDropdown(dropdown: countryDD, sender: btnCountryDD)
        
        selectedButton = btnWebLink
        txtSocialLinks.tag = 1
        
        txtDescription.delegate = self
        txtSocialLinks.delegate = self
        
        getCountryList()
        
    }
    
    
    func localizeUI() {
        self.title = LocalizedString(key: "editSalonDetail")
        lblGeneralHeader.text = LocalizedString(key: "general")
        txtName.placeholder = LocalizedString(key: "nameArtist")
        lblProfession.text = LocalizedString(key: "profession")
        txtDescription.text = LocalizedString(key: "description")
        lblSalonAddressHeader.text = LocalizedString(key: "editSalonAddressHeader")
        lblCountry.text = LocalizedString(key: "country")
        txtCity.placeholder = LocalizedString(key: "city")
        txtStreet.placeholder = LocalizedString(key: "street")
        txtZip.placeholder = LocalizedString(key: "zip")
        txtSalonName.placeholder = LocalizedString(key: "salon")
        
        lblSocialMedialHeader.text = LocalizedString(key: "socialMedia")
        txtSocialLinks.placeholder = LocalizedString(key: "websiteLinkPlaceHolder")
        
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
        btnNext.setTitle(LocalizedString(key: "next"), for: .normal)
    }
    
    func setupUI() {
        
        viewCorner.forEach({ $0.addCornerAndBorderStyle() })
        
        [txtName,txtBussinessURL,txtCity,txtStreet,txtZip,txtSalonName].forEach({ $0?.addCornerAndBorderStyle()
            $0?.customizeTextfield()
        })
        
        [btnWebLink,btnWhatsapp,btnFacebook,btnInstagram,btnYoutube,btnTwitter,btnGooglePlus,btnPinterest].forEach({ $0?.titleLabel?.font = UIFont.fontAwesome(ofSize: 12.0)
            $0?.tintColor = R.color.salonX.headerBG()
            $0?.layer.cornerRadius = 2.0
            $0?.clipsToBounds = true
        })
        
        lblPrecedURL.addCornerAndBorderStyle()
        lblPrecedURL.text = "http://192.168.0.10/salonx/salon_detail/\(getUserDetail(R.string.keys.salon_id()))/"
        
        btnWebLink.setTitle("\(String.fontAwesomeIcon(name: .desktop))", for: .normal)
        btnWhatsapp.setTitle("\(String.fontAwesomeIcon(name: .whatsapp))", for: .normal)
        btnFacebook.setTitle("\(String.fontAwesomeIcon(name: .facebook))", for: .normal)
        btnInstagram.setTitle("\(String.fontAwesomeIcon(name: .instagram))", for: .normal)
        btnYoutube.setTitle("\(String.fontAwesomeIcon(name: .youTube))", for: .normal)
        btnTwitter.setTitle("\(String.fontAwesomeIcon(name: .twitter))", for: .normal)
        btnGooglePlus.setTitle("\(String.fontAwesomeIcon(name: .googlePlus))", for: .normal)
        btnPinterest.setTitle("\(String.fontAwesomeIcon(name: .pinterestP))", for: .normal)
        
        txtSocialLinks.addCornerAndBorderStyle()
        txtSocialLinks.customizeTextfield()
        
        // Setup custom Placeholder into textField
        let attributes = [
            NSForegroundColorAttributeName: R.color.salonX.accent(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 14)! // Note the !
        ]
        
        let attribute1 = [
            NSForegroundColorAttributeName: R.color.salonX.headerBG(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15)!
        ]
        
        let st = NSMutableAttributedString()
        
        let text1 = NSAttributedString(string: "Bussiness URL : ", attributes:attribute1)
        let text2 = NSAttributedString(string: "www.salonx.com/johndoe", attributes:attributes)
        
        st.append(text1)
        st.append(text2)
        
        //txtBussinessURL.attributedPlaceholder = st
        
        localizeUI()
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
    
    func validateInput() -> Bool {
        
        var errorMessage = ""
        
        if !txtName.text!.trimmed().validateFirstName() {
            errorMessage += LocalizedString(key: "pleaseEnterName")
        }
        
        if selectedProfession == nil {
            errorMessage += LocalizedString(key: "pleaseChooseProfession")
        }
        
        if txtBussinessURL.text!.isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterBusinessURL")
        }
        
        if selectedCountry == nil {
            errorMessage += LocalizedString(key: "pleaseChooseCountry")
        }
        
        if txtCity.text!.isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterCity")
        }
        
        if txtStreet.text!.isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterStreetName")
        }
        
        if txtZip.text!.isEmpty {
            errorMessage += LocalizedString(key: "pleaseEnterZip")
        }
        
        if !txtSalonName.text!.trimmed().validateFirstName() {
            errorMessage += LocalizedString(key: "pleaseEnterSalonName")
        }
        
        
        if errorMessage.length > 0 {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx") , message: errorMessage)
        }
        
        return errorMessage.length == 0
    }
}

//MARK: - Newtwork Helper
extension EditSalonDetailViewController {
    
    func getCountryList() {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.countryList()
        
        if let userDetail = UserDefaults.standard.value(forKey: R.string.keys.userDetail()) as? NSData {
            let data = JSON(userDetail)
            print(data)
        }
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            Alamofire.request(kURL, method: .post, parameters: ["lang" : Language.shared.Lang], encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                
                self.getProfessionList()
                if response.result.isSuccess {
                    print(response.result.value)
                    if let json = response.result.value {
                        if json[R.string.keys.flag()].stringValue == "1" {
                            let data = json["data"].arrayValue
                            var list: [Country] = []
                            for item in data {
                                list.append(Country(county_id: item["county_id"].stringValue, county_name: item["county_name"].stringValue, is_del: item["is_del"].stringValue))
                            }
                            self.countryList = list
                            print(self.countryList)
                        }
                    }
                } else {
                    self.getCountryList()
                }
            }
        }
    }
    
    func getProfessionList() {
        
        let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     "lang": Language.shared.Lang,
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())]
        
        ProfesssionListWebService().professionListRequest(param: param) { (result) in
            BasicStuff.dismissLoader()
            if result.isSuccess {
                print(result)
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        let data = json["data"].arrayValue
                        self.professionItem = data
                        var list: [String] = []
                        
                        if isIndividualUser() {
                            for item in data {
                                list.append(item["individual_name"].stringValue)
                            }
                        } else {
                            for item in data {
                                list.append(item["proffession_name"].stringValue)
                            }
                        }
                        
                        self.professionDD.dataSource = list
                        print(self.professionItem)
                        
                    }
                }
            } else {
                self.getProfessionList()
            }
        }
        
    }
    
    func submitSalonDetail() {
        
        var param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                     "salon_name" : txtSalonName.text!,
                     "profession_type" : selectedProfession!,
                     "business_url" : txtBussinessURL.text!,
                     "description" : txtDescription.text!,
                     "country" : selectedCountry!,
                     "city" : txtCity.text!,
                     "street" : txtStreet.text!,
                     "zip" : txtZip.text!,
                     "name" : txtName.text!,
                     "lattitude" : "\(mapView.centerCoordinate.latitude)",
            "longtitude" : "\(mapView.centerCoordinate.longitude)",
            "lang" : Language.shared.Lang
        ]
        
        for (k,v) in socialProfile {
            if k == "1" {
                param["website_link"] = v
            } else if k == "2" {
                param["whatsapp_num"] = v
            } else if k == "3" {
                param["facebook_link"] = v
            }else if k == "4" {
                param["instagram_link"] = v
            }else if k == "5" {
                param["youtube_link"] = v
            }else if k == "6" {
                param["twitter_link"] = v
            }else if k == "7" {
                param["google_link"] = v
            }else if k == "8" {
                param["pintrest_link"] = v
            }
        }
        if Rechability.isConnectedToNetwork() {
        print(param)
        BasicStuff.showLoader(self.view)
        SaveSalonDetailWebService().saveSalonDetailRequest(param: param) { (result) in
            BasicStuff.dismissLoader()
            if let json = result.value {
                if json[R.string.keys.flag()].stringValue == "1" {
                    
                    print(json["data"])
                    
                    if self.pushType == .signup {
                        let vc = EditExtraDetailViewController()
                        vc.pushType = .signup
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: "Salon detail Saved.")
                    }
                    
                }
            }
        }
        } else {
             BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
}

//MARK: - Actions
extension EditSalonDetailViewController {
    
    @IBAction func btnWebLinkTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnWebLink
        txtSocialLinks.placeholder = LocalizedString(key: "websiteLinkPlaceHolder")
    }
    
    @IBAction func btnWhatsappTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnWhatsapp
        txtSocialLinks.placeholder = LocalizedString(key: "whatsAppPlaceHolder")
    }
    
    @IBAction func btnFacebookTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnFacebook
        txtSocialLinks.placeholder  = LocalizedString(key: "facebookPlaceHolder")
    }
    
    @IBAction func btnInstagramTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnInstagram
        txtSocialLinks.placeholder = LocalizedString(key: "instagramPlaceHolder")
    }
    
    @IBAction func btnYoutubeTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnYoutube
        txtSocialLinks.placeholder = LocalizedString(key: "youtubePlaceHolder")
    }
    
    @IBAction func btnTwitterTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnTwitter
        txtSocialLinks.placeholder = LocalizedString(key: "twitterPlaceHolder")
    }
    
    @IBAction func btnGooglePlusTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnGooglePlus
        txtSocialLinks.placeholder  = LocalizedString(key: "googlePlaceHolder")
    }
    
    @IBAction func btnPinterestTapped(_ sender: UIButton) {
        txtSocialLinks.resignFirstResponder()
        txtSocialLinks.tag = sender.tag
        selectedButton = btnPinterest
        txtSocialLinks.placeholder = LocalizedString(key: "pinterestPlaceHolder")
    }
    
    @IBAction func btnProfessionTapped(_ sender: UIButton) {
        professionDD.show()
        
        professionDD.selectionAction = { (index,item) in
            self.lblProfession.textColor = UIColor.black
            
            if isIndividualUser() {
                self.selectedProfession = self.professionItem[index]["individual_id"].stringValue
            } else {
                self.selectedProfession = self.professionItem[index]["salon_proffession_id"].stringValue
            }
            
            self.lblProfession.text = item
        }
    }
    
    @IBAction func btnCountryTapped(_ sender: UIButton) {
        countryDD.show()
        countryDD.selectionAction = { (index,item) in
            self.lblCountry.textColor = UIColor.black
            self.selectedCountry = self.countryList[index].county_id
            print(self.countryList[index].county_name)
            self.lblCountry.text = item
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        print(socialProfile)
        self.view.endEditing(true)
        txtSocialLinks.resignFirstResponder()
        
        if validateInput() {
            if Rechability.isConnectedToNetwork() {
                submitSalonDetail()
            }
        }
    }
}

//MARK: - Location Manager
extension EditSalonDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //mapView.centerCoordinate = location.coordinate
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
            userLocation = location
            print(location)
            locationManager.stopUpdatingLocation()
        }
    }
}

extension EditSalonDetailViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSocialLinks {
            socialProfile["\(txtSocialLinks.tag)"] = txtSocialLinks.text!
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtSocialLinks {
            if selectedButton == btnWhatsapp {
                guard let text = textField.text else {
                    return true
                }
                
                return UserInputValidator.digitsOnly(text: text, range: range, replacementString: string, maxLength: 12)
            }
        }
        return true
    }
    
}

//MARK: Textview delegate methods
extension EditSalonDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LocalizedString(key: "description") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LocalizedString(key: "description")
            textView.textColor = UIColor.lightGray
        }
    }
}
