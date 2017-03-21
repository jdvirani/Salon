//
//  AddServiceViewController.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

class AddServiceViewController: UIViewController {
    
    @IBOutlet weak var scrolView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet var viewCornerStyle: [UIView]!
    
    @IBOutlet weak var lblServiceHeader: UILabel!
    @IBOutlet weak var txtServiceName: UITextField!
    
    @IBOutlet weak var lblPriceHeader: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblDurationHeader: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnDecrement: UIButton!
    @IBOutlet weak var btnIncrement: UIButton!
    
    @IBOutlet weak var lblDescriptionHeader: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var lblCategoryHeader: UILabel!
    @IBOutlet weak var btnCategoryDD: UIButton!
    @IBOutlet weak var lblCategoryType: UILabel!
    
    @IBOutlet weak var lblSubCategoryHeader: UILabel!
    @IBOutlet weak var btnSubCategoryDD: UIButton!
    @IBOutlet weak var lblSubCategoryType: UILabel!
    
    @IBOutlet weak var lblGroupServiceHeader: UILabel!
    @IBOutlet weak var btnGroupServiceDD: UIButton!
    @IBOutlet weak var lblGroupService: UILabel!
    
    @IBOutlet weak var btnAddGroup: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var editMode = false
    var serviceItem: JSON?
    
    var groupName: String?
    
    var durationTag = 12 {
        didSet {
            lblDuration.text = "\(durationTag * 15) min"
        }
    }
    
    //DROPDOWN
    var categoryDD = DropDown()
    var subCategoryDD = DropDown()
    var groupServiceDD = DropDown()
    
    var groupList: [JSON] = []
    var categoryList: [JSON] = []
    
    var subCategoryList: [JSON] = [] {
        didSet {
            var subCategoryItem: [String] = []
            
            for item in subCategoryList {
                subCategoryItem.append(item["sub_category_name"].stringValue)
            }
            
            subCategoryDD.dataSource = subCategoryItem
        }
    }
    
    var selectedService: String?
    var selectedCategory: String?
    var selectedSubCategory: String?
    
    convenience init() {
        self.init(nibName: R.nib.addServiceVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationTag = 3
        
        setupUI()
        
        setupBackButton()
        
        configDropdown(dropdown: categoryDD, sender: btnCategoryDD)
        configDropdown(dropdown: subCategoryDD, sender: btnSubCategoryDD)
        configDropdown(dropdown: groupServiceDD, sender: btnGroupServiceDD)
        
        getCategoryList()
        
        if editMode {
            if serviceItem != nil {
                
                txtServiceName.text = serviceItem?["name"].stringValue
                txtPrice.text = serviceItem?["price"].stringValue.components(separatedBy: " ")[0]
                //lblDuration.text = serviceItem?["duration"].stringValue
                if let tag = serviceItem?["duration"].stringValue.components(separatedBy: " ")[0] {
                    durationTag = Int(tag)! / 15
                }
                txtDescription.text = serviceItem?["description"].stringValue
                selectedSubCategory = serviceItem?["sub_category"].stringValue
                selectedService = serviceItem?["service_id"].stringValue
            }
            lblGroupService.textColor = UIColor.black
            lblGroupService.text = groupName
        }
        
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
    
    func localizeUI() {
        self.title = LocalizedString(key: "addService")
        lblServiceHeader.text = LocalizedString(key: "serviceHeader")
        lblDurationHeader.text = LocalizedString(key: "durationHeader")
        lblPriceHeader.text = LocalizedString(key: "priceHeader")
        lblDescriptionHeader.text = LocalizedString(key: "descriptionHeader")
        lblCategoryHeader.text = LocalizedString(key: "categoryHeader")
        lblSubCategoryHeader.text = LocalizedString(key: "subCategoryHeader")
        lblGroupServiceHeader.text = LocalizedString(key: "groupService")
        
        lblGroupService.text = LocalizedString(key: "selectHere")
        lblCategoryType.text = LocalizedString(key: "selectHere")
        lblSubCategoryType.text = LocalizedString(key: "selectHere")
        btnAddGroup.setTitle(LocalizedString(key: "addGroup"), for: .normal)
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
        btnCancel.setTitle(LocalizedString(key: "cancel"), for: .normal)
    }
    
    func setupUI() {
        
        viewCornerStyle.forEach({  $0.addCornerAndBorderStyle() } )
        
        txtPrice.keyboardType = .numbersAndPunctuation
        
        txtServiceName.customizeTextfield()
        txtServiceName.addCornerAndBorderStyle()
        txtPrice.customizeTextfield()
        txtPrice.addCornerAndBorderStyle()
        txtDescription.addCornerAndBorderStyle()
        btnAddGroup.layer.cornerRadius = btnAddGroup.frame.height / 2
        btnAddGroup.clipsToBounds = true
        localizeUI()
    }
    
    func validateInput() -> Bool {
        
        var errorMessage = ""
        
        if txtServiceName.text!.trimmed().length > 0 {
            if !txtServiceName.text!.trimmed().validateFirstName() {
                errorMessage += LocalizedString(key: "invalidServiceName")
            }
        } else {
            errorMessage += LocalizedString(key: "serviceNameRequired")
        }
        
        
        if let text = txtPrice.text {
            if Double(text)! * 1.0 == 0.0 {
                errorMessage += LocalizedString(key: "priceNotZero") + "\n"
            }
        }
        
        if txtPrice.text!.trimmed().isEmpty {
            errorMessage += LocalizedString(key: "enterPrice") + "\n"
        }
        
        if selectedService == nil {
            errorMessage += LocalizedString(key: "selecteService") + "\n"
        }
        
        if !editMode {
            if selectedCategory == nil {
                errorMessage += LocalizedString(key: "selectCategory") + "\n"
            }
        }
        
        if selectedSubCategory == nil {
            errorMessage += LocalizedString(key: "selectSubCategory") + "\n"
        }
        
        if errorMessage.length > 0 {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: errorMessage)
        }
        
        return errorMessage.length == 0
    }
}

//MARK: NewWork Helper
extension AddServiceViewController {
    
    func getGroupList() {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.groupListURL()
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                          R.string.keys.lang() : Language.shared.Lang,
                          R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())]
            
            Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                
                BasicStuff.dismissLoader()
                
                if let json = response.result.value {
                    if json["flag"].stringValue == "1" {
                        self.groupList = json["data"].arrayValue
                        
                        var item: [String] = []
                        
                        for i in self.groupList {
                            item.append(i["name"].stringValue)
                        }
                        
                        self.groupServiceDD.dataSource = item
                        
                    }
                }
                
            }
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func getCategoryList() {
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            CategoryWebService().getCategoryListRequest { (result) in
                
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        
                        let data = json["data"]
                        self.categoryList = data["category"].arrayValue
                        
                        var categoryItem: [String] = []
                        
                        for item in self.categoryList {
                            categoryItem.append(item["super_category_name"].stringValue)
                        }
                        
                        BasicStuff.dismissLoader()
                        
                        printData(text: "Category Item", item: categoryItem)
                        self.categoryDD.dataSource = categoryItem
                        
                        self.getGroupList()
                    }
                    
                }
            }
        }
    }
    
    func addGroup(groupID: String, groupName: String) {
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "1",
                      "group_id" : groupID,
                      "group_name" : groupName,
                      "is_del" : "0"]
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            print(param)
            
            ManageSeviceWebService().manageSeviceRequest(param: param, completion: { (result) in
                
                if let json = result.value {
                    if json["flag"].stringValue == "1" {
                        
                        self.getGroupList()
                        
                        let msg = json["msg"].stringValue
                        NotificationCenter.default.post(name: NSNotification.Name("fetchService"), object: nil)
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: msg)
                        
                    } else if json["flag"].stringValue == "0" {
                        
                        let msg = json["msg"].stringValue
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: msg)
                    }
                }
            })
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    
    func addService(serviceID: String) {
        
        var param: [String : String] = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                                         R.string.keys.lang() : Language.shared.Lang,
                                         R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                                         "flag_view" : "2",
                                         "service_id" : serviceID,
                                         "service_name" : txtServiceName.text!,
                                         "price" : txtPrice.text!,
                                         "duration" : "\(durationTag * 15)",
                                         "description" : txtDescription.text,
                                         "sub_category_id" : selectedSubCategory!,
                                         "service_group_id" : selectedService!,
                                         "is_del" : "0"]
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            print(param)
            
            ManageSeviceWebService().manageSeviceRequest(param: param, completion: { (result) in
                BasicStuff.dismissLoader()
                
                if let json = result.value {
                    let msg = json["msg"].stringValue
                    NotificationCenter.default.post(name: NSNotification.Name("fetchService"), object: nil)
                    BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: msg)
                }
            })
            
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
}

//MARK: - Actions
extension AddServiceViewController: NewGroupAddedDelegate {
    
    @IBAction func btnIncrementTapped(_ sender: UIButton) {
        if durationTag < 12 {
            durationTag += 1
        }
    }
    
    @IBAction func btnDecrementTapped(_ sender: UIButton) {
        if durationTag > 0 {
            durationTag -= 1
        }
    }
    
    @IBAction func btnCategoryTypeTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        categoryDD.show()
        categoryDD.selectionAction = { (index,item) in
            
            self.subCategoryDD.dataSource = []
            
            self.lblCategoryType.textColor = UIColor.black
            self.lblCategoryType.text = item
            
            self.selectedCategory = self.categoryList[index]["super_category_id"].stringValue
            
            self.subCategoryList = self.categoryList[index]["sub_category"].arrayValue
            
            printData(text: "category Lit", item: self.subCategoryList)
            
            // Change apperance of Sub Category Dropdown
            self.selectedSubCategory = nil
            self.lblSubCategoryType.text = "select here"
            self.lblSubCategoryType.textColor = R.color.salonX.headerBG()
            
        }
    }
    
    @IBAction func btnSubCategoryTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        subCategoryDD.show()
        subCategoryDD.selectionAction = { (index,item) in
            
            self.lblSubCategoryType.textColor = UIColor.black
            self.lblSubCategoryType.text = item
            
            self.selectedSubCategory = self.subCategoryList[index]["sub_category_id"].stringValue
            self.selectedCategory = self.subCategoryList[index]["super_category_id"].stringValue
        }
    }
    
    @IBAction func btnAddGroupTapped(_ sender: UIButton) {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let popup = AddGroupPopupViewController()
        popup.modalPresentationStyle = .overCurrentContext
        popup.newGroupAddedDelegate = self
        present(popup, animated: true, completion: nil)
    }
    
    @IBAction func btnGroupServiceTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        groupServiceDD.show()
        groupServiceDD.selectionAction = { (index,item) in
            
            self.selectedService = self.groupList[index]["group_id"].stringValue
            
            self.lblGroupService.textColor = UIColor.black
            self.lblGroupService.text = item
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        print(selectedSubCategory)
        
        print(selectedService)
        
        print(durationTag * 15)
        
        if validateInput() {
            if editMode {
                addService(serviceID: serviceItem!["service_id"].stringValue)
            } else {
                addService(serviceID: "0")
            }
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func didNewGroupAdded(groupName: String) {
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        print(groupName)
        
        addGroup(groupID: "0", groupName: groupName)
        
    }
}
