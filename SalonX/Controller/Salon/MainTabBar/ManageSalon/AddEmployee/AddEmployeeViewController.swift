//
//  AddEmployeeViewController.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

class AddEmployeeViewController: UIViewController {
    
    @IBOutlet weak var lblEmployeeHeader: UILabel!
    @IBOutlet weak var imgSelectImage: UIImageView!
    @IBOutlet weak var txtEmployeeName: UITextField!
    @IBOutlet weak var viewSpecility: UIView!
    @IBOutlet weak var lblSpecility: UILabel!
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var pushType: PushType = .login
    
    var isEditMode = false
    var employeeDetail: JSON?
    var selectedSpeciality: String?
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    var specilityDD = DropDown()
    var serviceDD = DropDown()
    var specilityItems = ["1","2"]
    
    var selectedSeviceId: String?
    
    var serviceListItem: [JSON] = [] {
        didSet {
            
            var serviceItems: [String] = []
            
            for item in serviceListItem {
                serviceItems.append(item["name"].stringValue)
            }
            
            print(serviceItems)
            self.serviceDD.dataSource = serviceItems
        }
    }
    
    var selectedServiceItem : [JSON] = []  {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init() {
        self.init(nibName: R.nib.addEmployeeVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditMode {
            
            if let imageURL = URL(string: employeeDetail!["profile_pic"].stringValue) {
                imgSelectImage.sd_setImage(with: imageURL, placeholderImage: R.image.placeholder_employee(), options: .highPriority)
            }
            
            txtEmployeeName.text = employeeDetail!["name"].stringValue
            lblSpecility.text = employeeDetail!["speciality"].stringValue
            selectedSpeciality = employeeDetail!["service_id"].stringValue
            
        }
        
        setupUI()
        setupTableUI()
        configDropdown(dropdown: specilityDD, sender: viewSpecility)
        configDropdown(dropdown: serviceDD, sender: viewService)
        
        specilityDD.dataSource = specilityItems
        
        getServiceList()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.title = "Add Employee"
        
        setupBackButton()
        imgSelectImage.layer.cornerRadius = 3.0
        imgSelectImage.clipsToBounds = true
        txtEmployeeName.customizeTextfield()
        txtEmployeeName.addCornerAndBorderStyle()
        viewSpecility.addCornerAndBorderStyle()
        viewService.addCornerAndBorderStyle()
        localizeUI()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "addEmployee")
        lblEmployeeHeader.text = LocalizedString(key: "employeeHeader")
        lblSpecility.text = LocalizedString(key: "speciality")
        lblService.text = LocalizedString(key: "selectService")
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
        btnCancel.setTitle(LocalizedString(key: "cancel"), for: .normal)
    }
    
    func setupTableUI() {
        tableView.register(R.nib.serviceCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 37.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
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
}

extension AddEmployeeViewController {
    
    func getServiceList() {
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                          R.string.keys.lang() : Language.shared.Lang,
                          R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
            ]
            
            GetServiceList().getServiceListRequest(param: param, completion: { (result) in
            BasicStuff.dismissLoader()
            
            if let json = result.value {
                if json[R.string.keys.flag()].stringValue == "1" {
                    
                    self.serviceListItem = json["data"].arrayValue
                    
                    if self.isEditMode {
                        let services = self.selectedSpeciality!.components(separatedBy: ",")
                        
                        for item in services {
                            if self.serviceListItem.contains(where: { $0["service_id"].stringValue == item}) {
                                let index = self.serviceListItem.index(where: { $0["service_id"].stringValue == item })
                                self.selectedServiceItem.append(self.serviceListItem[index!])
                                self.serviceListItem.remove(at: index!)
                            }
                        }
                    }
                    
                }
            }
           })
        
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func saveEmployeeDetail(employeeID: String,employeeServices: String) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.manageEmployeeURL()
        
        let param: [String : String] = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "1",
                      "emp_id" : employeeID,
                      "emp_name" : txtEmployeeName.text!,
                      "emp_speciality" : lblSpecility.text!,
                      "emp_service" : employeeServices,
                      "is_del" : "0"
        ]
        
        print(param)
        if Rechability.isConnectedToNetwork() {
            
            let manager = ServiceCall(URL: kURL)
            manager.setContentType(contentType: .multiPartForm)
            manager.setAuthorization(username: R.string.keys.authUsername(), password: R.string.keys.authPassword())
            
            BasicStuff.showLoader(self.view)
            manager.POST(params: param as NSDictionary, appendBodyWithBlock: { (multiPartData) in
                
                if selectedImage != nil {
                    if let imageData = UIImageJPEGRepresentation(selectedImage!, 0.6) {
                        multiPartData.appendData(data: imageData, Key: "emp_picture", fileName: "file.png")
                    }
                }
                
            }) { (status, response) in
                print(response)
                BasicStuff.dismissLoader()
                if status {
                    
                }
            }
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
}

//MARK: - Actions
extension AddEmployeeViewController{
    
    @IBAction func btnSelectImageTapped(_ sender: UIButton) {
        
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
        
        if pushType == .signup {
            present(imageOptionController, animated: true, completion: nil)
        } else {
            tabBarController?.present(imageOptionController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSpecialityDDTapped(_ sender: UIButton) {
        
        specilityDD.show()
        
        specilityDD.selectionAction = { (index,item) in
            self.lblSpecility.text = item
            self.selectedSpeciality = item
        }
    }
    
    @IBAction func btnServiceDDTapped(_ sender: UIButton) {
        serviceDD.show()
        
        serviceDD.selectionAction = { (index,item) in
            
            let service = self.serviceListItem[index]
            self.selectedServiceItem.append(service)
            self.serviceListItem.remove(at: index)
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        var serviceId = ""
        
        for i in 0..<selectedServiceItem.count - 1 {
            serviceId += selectedServiceItem[i]["service_id"].stringValue
            serviceId += ","
        }
        
        if let _ = selectedServiceItem.last {
            serviceId += selectedServiceItem.last!["service_id"].stringValue
        }
        
        if isEditMode {
            saveEmployeeDetail(employeeID: employeeDetail!["employee_id"].stringValue, employeeServices: serviceId)
        } else {
            saveEmployeeDetail(employeeID: "0", employeeServices: serviceId)
        }
        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddEmployeeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgSelectImage.image = image
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

extension AddEmployeeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedServiceItem.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ServiceTableViewCell
        
        cell.lblServiceName.text = selectedServiceItem[indexPath.row]["name"].stringValue
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func btnDeleteTapped(_ sender: UIButton) {
        
        let service = selectedServiceItem[sender.tag]
        serviceListItem.append(service)
        selectedServiceItem.remove(at: sender.tag)
    }
}
