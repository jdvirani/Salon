//
//  ManageEmployeeViewController.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import SwiftyJSON

class ManageEmployeeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var bottomOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    var pushType: PushType = .login
    
    var employeeList: [JSON] = []
    
    convenience init() {
        self.init(nibName: R.nib.manageEmployeeVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pushType == .login {
            setupBackButton()
            buttonHeight.constant = 0.0
            bottomOfCollectionView.constant = 0.0
            btnSave.isHidden = true
        } else {
            self.navigationItem.hidesBackButton = true
            bottomOfCollectionView.constant = 40.0
            buttonHeight.constant = 40.0
            btnSave.isHidden = false
        }
        setupUI()
        setupCollectionViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEmployeeList()
    }
    
    func setupCollectionViewUI() {
        collectionView.register(R.nib.employeeCell(), forCellWithReuseIdentifier: "cell")
    }
    
    func setupUI() {

        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "ic_add_client"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(self.addEmployeeTapped(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        navigationItem.rightBarButtonItem = item1
        localizeUI()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "manageEmployee")
    }
    
    func addEmployeeTapped(_ :UIBarButtonItem) {
        if pushType == .signup {
            let vc = AddEmployeeViewController()
            vc.pushType = .signup
            vc.isEditMode = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        if !employeeList.isEmpty {
            let vc = ManageProgramViewController()
            vc.pushType = .signup
            navigationController?.pushViewController(vc, animated: true)
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "addAtleastOneEmployee"))
        }
    }
}

//MARK: - Network Helper
extension ManageEmployeeViewController {
    
    func getEmployeeList() {
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "0"]
        
         if Rechability.isConnectedToNetwork() {
            BasicStuff.showLoader(self.view)
            
            ManageEmployeeService().manageEmployeeRequest(param: param) { (result) in
                print(result.value)
                BasicStuff.dismissLoader()
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        
                        self.employeeList = json["data"].arrayValue
                        print(self.employeeList)
                        self.collectionView.reloadData()
                    }
                }
            }
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func deleteEmployeeOperation(employeeID: String, index: Int) {
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "1",
                      "emp_id" : employeeID,
                      "is_del" : "1"]
        
         if Rechability.isConnectedToNetwork() {
            BasicStuff.showLoader(self.view)
            ManageEmployeeService().manageEmployeeRequest(param: param) { (result) in
                
                BasicStuff.dismissLoader()
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json[R.string.keys.msg()].stringValue)
                        
                        self.employeeList.remove(at: index)
                        self.collectionView.reloadData()
                        
                    }
                }
            }
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
}

extension ManageEmployeeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmployeeCollectionViewCell
        
        cell.imgEmployee.layer.cornerRadius = 3.0
        cell.imgEmployee.clipsToBounds = true
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteEmployee(_:)), for: .touchUpInside)
        
        if let imgURL = URL(string: employeeList[indexPath.row]["profile_pic"].stringValue) {
            
            cell.imgEmployee.sd_setImage(with: imgURL, placeholderImage: R.image.placeholder_employee(), options: .highPriority)
        } else {
            cell.imgEmployee.image = R.image.placeholder_employee()
        }
        
        cell.lblName.text = employeeList[indexPath.row]["name"].stringValue
        cell.lblSpecialist.text = employeeList[indexPath.row]["speciality"].stringValue
        
        cell.lblTotalReview.text = "(\(employeeList[indexPath.row]["rat_total"].stringValue))"
        
        let avg = employeeList[indexPath.row]["rat_avg"].stringValue
        
        cell.lblratingView.setScore(Float(avg)! / 5.0, withAnimation: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let employeeDetail = employeeList[indexPath.row]
        
        print(employeeList)
        
        if pushType == .signup {
            let vc = AddEmployeeViewController()
            vc.pushType = .signup
            vc.isEditMode = true
            vc.employeeDetail = employeeDetail
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: ((UIScreen.main.bounds.width / 2 - 10) + 56.0))
    }
    
    func deleteEmployee(_ sender: UIButton) {
        
        print(employeeList[sender.tag]["name"].stringValue)
        let employeeID = employeeList[sender.tag]["employee_id"].stringValue
        
        let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "confirmDeleteEmployeeMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: LocalizedString(key: "Ok"), style: .default) { (action) in
            self.deleteEmployeeOperation(employeeID: employeeID, index: sender.tag)
        }
        
        let cancelAction = UIAlertAction(title: LocalizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
