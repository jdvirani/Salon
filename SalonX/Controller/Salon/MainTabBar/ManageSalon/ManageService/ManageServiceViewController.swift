//
//  ManageServiceViewController.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManageServiceViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddGroup: UIButton!
    @IBOutlet weak var btnAddService: UIButton!
    @IBOutlet weak var btnSave: UIButton!
   // @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
   // @IBOutlet weak var bottomOfTableView: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    var pushType: PushType = .login
    
    var serviceListItems: [JSON] = []
    
    var mainServiceListItems: [JSON] = []
    
    var groupListItem: [JSON] = []
    

    var offset = 0 {
        didSet {
            if offset == 0 {
                serviceListItems = []
            }
        }
    }
    
    var isHaveMoreService = true
    
    var isEditGroup = false
    var selectedGroupID: String?
    
    convenience init() {
        self.init(nibName: R.nib.manageServiceVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchService), name: NSNotification.Name(rawValue: "fetchService"), object: nil)
        
        if pushType == .login {
            setupBackButton()
            buttonHeight.constant = 0.0
           // bottomOfTableView.constant = 0.0
            btnSave.isHidden = true
        } else {
            self.navigationItem.hidesBackButton = true
            //bottomOfTableView.constant = 40.0
            buttonHeight.constant = 40.0
            btnSave.isHidden = false
        }
        
        scrollView.delegate = self
        
        setupUI()
        setUpTableUI()
        
        getMainServiceList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        
        //tableHeight.constant = (tableView.contentSize.height * 0.95) - (UIScreen.main.bounds.height - 56)
        self.view.layoutIfNeeded()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "manageService")
        btnAddGroup.setTitle(LocalizedString(key: "addGroup"), for: .normal)
        btnAddService.setTitle(LocalizedString(key: "addService"), for: .normal)
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
    }
    
    func setupUI() {
        
        btnAddGroup.layer.cornerRadius = btnAddGroup.frame.height / 2
        btnAddGroup.clipsToBounds = true
        btnAddService.layer.cornerRadius = btnAddService.frame.height / 2
        btnAddService.clipsToBounds = true
        localizeUI()
    }
    
    func setUpTableUI() {
        tableView.register(R.nib.serviceHeaderCell(), forCellReuseIdentifier: "headerCell")
        tableView.register(R.nib.serviceItemCell(), forCellReuseIdentifier: "itemCell")
        tableView.estimatedRowHeight = 72.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    //If any changes like service added of edited than refetch the service
    func fetchService() {
        
        serviceListItems.removeAll()
        self.offset = 0
        self.isHaveMoreService = true
        getMainServiceList()
        
        //self.getServiceList()
    }
}

//MARK: - Network Helper
extension ManageServiceViewController {
    
    func getMainServiceList() {
        
         if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                          R.string.keys.lang() : Language.shared.Lang,
                          R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
            ]
            
            GetServiceList().getServiceListRequest(param: param, completion: { (result) in
                BasicStuff.dismissLoader()
                self.getServiceList()
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        
                        self.mainServiceListItems = json["data"].arrayValue
                    }
                }
            })
            
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
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
                BasicStuff.dismissLoader()
                if let json = result.value {
                    if json["flag"].stringValue == "1" || json["flag"].stringValue == "0" {
                        let msg = json["msg"].stringValue
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: msg)
                        
                        self.offset = 0
                        self.isHaveMoreService = true
                        self.getServiceList()
                        
                        self.selectedGroupID = nil
                        self.isEditGroup = false
                    }
                }
            })
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func getServiceList() {
        
        if !isHaveMoreService {
            return
        }
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "0",
                      "offset" : "\(offset)"]
        
         if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            print(param)
            
            ManageSeviceWebService().manageSeviceRequest(param: param, completion: { (result) in
                if result.isSuccess {
                BasicStuff.dismissLoader()
                if let json = result.value {
                    print(json)
                    if json[R.string.keys.flag()].stringValue == "1" {
                        self.offset = json["next_offset"].intValue
                        
                        if self.offset == -1 {
                            self.isHaveMoreService = false
                        }
                        
                        self.serviceListItems += json["data"].arrayValue
                        self.tableView.reloadData()
                    }
                }
                } else {
                    BasicStuff.dismissLoader()
                }
            })
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func deleteGroup(groupID: String) {
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "1",
                      "group_id" : groupID,
                      "is_del" : "1"]
        
         if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            print(param)
            
            ManageSeviceWebService().manageSeviceRequest(param: param, completion: { (result) in
                print(result.value)
                BasicStuff.dismissLoader()
                
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "groupDeleted"))
                        
                        self.offset = 0
                        self.isHaveMoreService = true
                        self.getServiceList()
                        
                    }
                }
            })
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func deleteServiceOperation(serviceID: String) {
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "2",
                      "service_id" : serviceID,
                      "is_del" : "1"]
        
        if Rechability.isConnectedToNetwork() {
            BasicStuff.showLoader(self.view)
            print(param)
            
            ManageSeviceWebService().manageSeviceRequest(param: param, completion: { (result) in
                print(result.value)
                BasicStuff.dismissLoader()
                
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        let msg = json["msg"].stringValue
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: msg)
                        
                        self.offset = 0
                        self.isHaveMoreService = true
                        self.getServiceList()
                    }
                }
            })
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
}

//MARK: - Pagination
extension ManageServiceViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            getServiceList()
        }
    }
}

//MARK: - Actions
extension ManageServiceViewController: NewGroupAddedDelegate {
    
    @IBAction func btnAddGroupTapped(_ sender: UIButton) {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let popup = AddGroupPopupViewController()
        popup.modalPresentationStyle = .overCurrentContext
        popup.newGroupAddedDelegate = self
        present(popup, animated: true, completion: nil)
    }
    
    @IBAction func btnAddServiceTapped(_ sender: UIButton) {
        let vc = AddServiceViewController()
        vc.editMode = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        if !mainServiceListItems.isEmpty {
            if isIndividualUser() {
                let vc = ManageProgramViewController()
                vc.pushType = .signup
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ManageEmployeeViewController()
                vc.pushType = .signup
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
             BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "addAtleastOneService"))
        }
    }
    
    func didNewGroupAdded(groupName: String) {
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        dismiss(animated: true, completion: nil)
        print(groupName)
        
        if isEditGroup {
            addGroup(groupID: selectedGroupID!, groupName: groupName)
            
        } else {
            addGroup(groupID: "0", groupName: groupName)
        }
        
    }
    
}

extension ManageServiceViewController: UITableViewDelegate, UITableViewDataSource, ServiceIndexDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return serviceListItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serviceListItems[section]["services"].arrayValue.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! ServiceHeaderTableViewCell
        
        cell.lblGroupName.text = serviceListItems[section]["name"].stringValue
        cell.btnEditGroup.tag = section
        cell.btnDeleteGroup.tag = section
        
        cell.btnEditGroup.addTarget(self, action: #selector(btnEditHeaderTapped), for: .touchUpInside)
        cell.btnDeleteGroup.addTarget(self, action: #selector(btnDeleteHeaderTapped), for: .touchUpInside)
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ServiceItemTableViewCell
        
        cell.btnEdit.tag = indexPath.row
        cell.btnDeleteService.tag = indexPath.row
        cell.index = indexPath
        cell.serviceIndexDelegate = self
        cell.selectionStyle = .none
        
        let service = serviceListItems[indexPath.section]["services"].arrayValue
        
        cell.lblPrice.text = service[indexPath.row]["price"].stringValue
        cell.lblDuration.text = "\(service[indexPath.row]["duration"].stringValue)"
        cell.lblServiceName.text = service[indexPath.row]["name"].stringValue
        
        return cell
    }
  
}

//MARK: - TableView Actions
extension ManageServiceViewController {
    
    // Header Edit/Delete operation
    func btnEditHeaderTapped(_ sender: UIButton) {
        
        print(serviceListItems[sender.tag]["name"].stringValue)
        
        isEditGroup = true
        selectedGroupID = serviceListItems[sender.tag]["group_id"].stringValue
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        let popup = AddGroupPopupViewController()
        popup.isEditMode = true
        
        let name = ["name" : serviceListItems[sender.tag]["name"].stringValue]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editGroupName"), object: name)
        
        popup.modalPresentationStyle = .overCurrentContext
        popup.newGroupAddedDelegate = self
        present(popup, animated: true, completion: nil)
    }
    
    func btnDeleteHeaderTapped(_ sender: UIButton) {
        print(serviceListItems[sender.tag]["name"])
        
        let groupId = serviceListItems[sender.tag]["group_id"].stringValue
        
        let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "confirmDeleteGroupMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: LocalizedString(key: "Ok"), style: .default) { (action) in
            self.deleteGroup(groupID: groupId)
        }
        
        let cancelAction = UIAlertAction(title: LocalizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Edit and Delete operation for Service
    func editService(atIndex: IndexPath) {
        
        let serviceArray = serviceListItems[atIndex.section]["services"].arrayValue
        let serviceItem = serviceArray[atIndex.row]
        print(serviceItem)
        let vc = AddServiceViewController()
        vc.serviceItem = serviceItem
        vc.groupName = serviceListItems[atIndex.section]["name"].stringValue
        vc.editMode = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteService(atIndex: IndexPath) {
        
        let service = serviceListItems[atIndex.section]["services"].arrayValue
        
        print(service[atIndex.row]["name"].stringValue)
        let serviceId = service[atIndex.row]["service_id"].stringValue
        print(serviceId)
        
        let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "confirmDeleteServiceMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: LocalizedString(key: "Ok"), style: .default) { (action) in
            self.deleteServiceOperation(serviceID: serviceId)
        }
        
        let cancelAction = UIAlertAction(title: LocalizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
