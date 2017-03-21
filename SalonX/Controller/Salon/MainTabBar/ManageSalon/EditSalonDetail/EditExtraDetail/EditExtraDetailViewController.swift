//
//  EditExtraDetailViewController.swift
//  SalonX
//
//  Created by DK on 17/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditExtraDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblNewUtilityHeight: NSLayoutConstraint!
    @IBOutlet weak var viewMainHeight: NSLayoutConstraint!
    
    @IBOutlet var btnApperance: [UIButton]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblNewUtitlity: UITableView!
    @IBOutlet weak var btnAddUtility: UIButton!
    
    @IBOutlet weak var lblUtilityHeader: UILabel!
    @IBOutlet weak var lblRulesForSalonHeader: UILabel!
    @IBOutlet weak var txtRules: UITextView!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnNext: UIButton!
 
    var pushType: PushType = .login
    
    var utilityList: [JSON] = [] {
        didSet {
            tableView.reloadData()
            tblHeightConstraint.constant = CGFloat(utilityList.count * 45)
        }
    }
    
    var newUtility: [String] = [""]
    
    var count = 0 {
        didSet {
            if count == 0{
                newUtility.removeAll()
                newUtility.append("")
                count = 1
            }
            tblNewUtitlity.reloadData()
            tblNewUtilityHeight.constant = CGFloat(count * 45)
        }
    }
    
    convenience init() {
        self.init(nibName: R.nib.editExtraDetailVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pushType == .login {
            setupBackButton()
            btnNext.isHidden = true
        } else {
            self.navigationItem.hidesBackButton = true
            btnSave.isHidden = true
        }
        
        count = 1
        
        setupUI()
        setupTableUI()
        
        txtRules.text = getUserDetail("rule")
        
        fetchDetail()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        viewMainHeight.constant = tblHeightConstraint.constant + tblNewUtilityHeight.constant + 398
        
        self.view.layoutIfNeeded()
    }
    
    func setupTableUI() {
        tableView.register(R.nib.utilityCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 51
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        tblNewUtitlity.register(R.nib.utilityCell(), forCellReuseIdentifier: "cell")
        tblNewUtitlity.estimatedRowHeight = 51
        tblNewUtitlity.rowHeight = UITableViewAutomaticDimension
        tblNewUtitlity.separatorStyle = .none
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "editExtraDetail")
        lblUtilityHeader.text = LocalizedString(key: "utilityForSalon")
        btnAddUtility.setTitle(LocalizedString(key: "addUtility"), for: .normal)
        lblRulesForSalonHeader.text = LocalizedString(key: "rulesForSalon")
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
        btnNext.setTitle(LocalizedString(key: "next"), for: .normal)

    }
    
    func setupUI() {
        btnApperance.forEach({ $0.addCornerAndBorderStyle() })
        txtRules.addCornerAndBorderStyle()
        
        localizeUI()
    }
}

//MARK: - Acitons
extension EditExtraDetailViewController {
    
    @IBAction func btnAddUtilityTapped(_ sender: UIButton) {
        
        view.endEditing(true)
        
        var temp: [String] = []
        
        for i in 0..<count {
            
            let cell = tblNewUtitlity.cellForRow(at: IndexPath(row: i, section: 0)) as! UtilityTableViewCell
            
            if i == count-1 {
                if cell.txtUtilityName.text!.trimmed().isEmpty {
                    return
                }
            }
            
            temp.append(cell.txtUtilityName.text!)
        }
        
        newUtility.removeAll()
        newUtility = temp
        newUtility.append("")
        count += 1
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        view.endEditing(true)
        
        print(newUtility)
        
        var newUtilityParam = NSMutableArray()
        
        for i in 0..<count {
            let cell = tblNewUtitlity.cellForRow(at: IndexPath(row: i, section: 0)) as! UtilityTableViewCell
            if !cell.txtUtilityName.text!.isEmpty {
                var param = NSDictionary()
                param = ["utility_id":"0","title":cell.txtUtilityName.text!]
                
                newUtilityParam.add(param)
                
            }
        }
        
        for i in 0..<utilityList.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! UtilityTableViewCell
            
            if !cell.txtUtilityName.text!.isEmpty {
                
                var param = NSDictionary()
                
                param = ["utility_id": utilityList[i]["utility_id"].stringValue,"title":utilityList[i]["utility_id"].stringValue]
                
                newUtilityParam.add(param)
            }
        }
        
        var errorMessage = ""

        if txtRules.text.isEmpty {
            errorMessage += LocalizedString(key: "pleaseAddSalonRules")
        }
        
        if newUtilityParam.count <= 0 {
            errorMessage += LocalizedString(key: "pleaseAddSomeUtilities")
        }
        
        if errorMessage.length == 0 {
             saveExtraDetail(param: newUtilityParam)
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: errorMessage)
        }
    
    }
    
}

extension EditExtraDetailViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            
            return utilityList.count
            
        } else {
            
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UtilityTableViewCell
            cell.selectionStyle = .none
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteTapped(_:)), for: .touchUpInside)
            cell.txtUtilityName.text = utilityList[indexPath.row]["title"].stringValue
            return cell
            
        } else {
            
            let cell =  self.tblNewUtitlity.dequeueReusableCell(withIdentifier: "cell") as! UtilityTableViewCell
            cell.selectionStyle = .none
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.deleteNewUtility(_:)), for: .touchUpInside)
            
            if indexPath.row < count {
                cell.txtUtilityName.text = newUtility[indexPath.row]
            }
            
            return cell
        }
    }
    
    func btnDeleteTapped(_ sender: UIButton) {
        
        let id = utilityList[sender.tag]["utility_id"].stringValue
        
        let param = ["utility_id" : id,
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                     R.string.keys.lang() : Language.shared.Lang]
        
        deleteUtilityWebService(param: param, completion: { (status) in
            if status {
                self.utilityList.remove(at: sender.tag)
            }
        })
    }
    
    func deleteNewUtility(_ sender: UIButton) {
        print(sender.tag)
        newUtility.remove(at: sender.tag)
        count -= 1
        print(newUtility)
    }
    
}

//MARK: - Network Helper
extension EditExtraDetailViewController {
    
    func fetchDetail() {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.saveExtraDetail()
        
        let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                     "flag_view" : "0",
                     R.string.keys.lang() : Language.shared.Lang]
        
        if Rechability.isConnectedToNetwork() {
            
            print(param)
            BasicStuff.showLoader(self.view)
            
            Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                
                print(response)
                BasicStuff.dismissLoader()
                
                if let json = response.result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        
                        let data = json["data"]["utilities"].arrayValue
                        self.utilityList = data
                        print(self.utilityList)
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
             BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func saveExtraDetail(param: NSMutableArray) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.saveExtraDetail()
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: param,
            options: []) {
            if let theJSONText = String(data: theJSONData,
                                        encoding: .ascii) {
                print("JSON string = \(theJSONText)")
                
                
                let paramForSave = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                                    R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
                    ,
                                    "flag_view" : "1",
                                    "rules" : txtRules.text,
                                    "utilities" : theJSONText,
                                    R.string.keys.lang() : Language.shared.Lang] as [String : Any]
                
               if Rechability.isConnectedToNetwork() {
                    BasicStuff.showLoader(self.view)
                    
                    Alamofire.request(kURL, method: .post, parameters: paramForSave, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                        
                        print(response)
                        BasicStuff.dismissLoader()
                        
                        if let json = response.result.value {
                            if json[R.string.keys.flag()].stringValue == "1" {
                                
                                if self.pushType == .signup {
                                    
                                    let vc = ManagePicturesViewController()
                                    vc.pushType = .signup
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                } else {
                                    BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json["msg"].stringValue)
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
    
    func deleteUtilityWebService(param: [String: String], completion: @escaping (Bool) -> ()) {
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.deleteUtilityURL()
        
        if Rechability.isConnectedToNetwork() {
            
            print(param)
            BasicStuff.showLoader(self.view)
            Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                
                print(response)
                
                BasicStuff.dismissLoader()
                
                if let json = response.result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        
                        BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json["msg"].stringValue)
                        
                        completion(true)
                    }
                }
            }
        } else {
             BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
}

////MARK: Textview delegate methods
//extension EditExtraDetailViewController: UITextViewDelegate {
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == txtRules {
//            if textView.text == "write here..." {
//                textView.text = nil
//                textView.textColor = UIColor.black
//            }
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView == txtRules {
//            if textView.text.isEmpty {
//                textView.text = "write here..."
//                textView.textColor = UIColor.lightGray
//            }
//        }
//    }
//}
