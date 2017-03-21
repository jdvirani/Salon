//
//  HomeSearchVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/25/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class HomeSearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderDelegate,UITextFieldDelegate {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblSearchResult: UITableView!
    @IBOutlet weak var SearchResultView: UIView!
    @IBOutlet weak var tblHomeSerch: UIExpandableTableView!
    var getHomeData:NSDictionary? = NSDictionary()
    
    var isSearchEnable:Bool = false
    
    var sectionCategoryArray:NSMutableArray = NSMutableArray()
    var categoryArray = NSMutableArray()
    
    var searchArray:NSMutableArray = NSMutableArray()
    
//    var HomePopDataArray = ["All Services","Women Haircut","Mens Haircut","Color","Treatments","Updo","Braids"]
    var SearchResultSection = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataSearch = getHomeData {
                let getArray  = dataSearch["category"] as! NSArray
                for i in 0..<getArray.count {
                    let dicData = getArray[i] as! NSDictionary
                    if (dicData.value(forKey: "super_category_id") as? String) != nil {
                        categoryArray.add(dicData)
                    }
                }
        }
        
        print("categoryArray:=\(categoryArray)")
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
        let HeaderView = UIButton.init(frame: CGRect(x: 0, y: -20, width: 42, height: 22))
        HeaderView.setBackgroundImage(UIImage(named: "logo_header"), for: .normal)
        self.navigationItem.titleView = HeaderView
    
        let buttonfilter = UIBarButtonItem(image: UIImage(named: "ic_filter_header"), style: .plain, target: self, action: #selector(self.btn_FilterAction(_:)))
        self.navigationItem.rightBarButtonItem = buttonfilter
        
        self.SearchResultView.isHidden = true
        
        let HomeHederSubCellNib = UINib(nibName: "HomeSearchHeaderSubCell", bundle: nil)
        tblHomeSerch.register(HomeHederSubCellNib, forCellReuseIdentifier: "HomeSearchHeaderSubCell")
        
        let HomeSearchResultNib = UINib(nibName: "HomeSearchResultSubCell", bundle: nil)
        tblSearchResult.register(HomeSearchResultNib, forCellReuseIdentifier: "HomeSearchCell")

        tblHomeSerch.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalizedStaticText()
    }
    
    
//  MARK:- Custom Function
    
    func getSearchList() {
       
        BasicStuff.showLoader(self.view)
        let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
        let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(txtSearch.text!, forKey: "keyword")
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        
        let manager = ServiceCall(URL: API_HomeSearchList)
        manager.setContentType(contentType: .multiPartForm)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                    let dataSearch = Obj.value(forKey: "data") as! NSDictionary
                    let serviceArray = dataSearch["service"] as! NSArray
                    let businessArray = dataSearch["business"] as! NSArray
                    if serviceArray.count != 0 {
                        self.searchArray.add(serviceArray)
                        self.SearchResultSection.append("Services")
                    }
                    if businessArray.count != 0 {
                        self.searchArray.add(businessArray)
                        self.SearchResultSection.append("Bussiness")
                    }
                    print("searchArray:=\(self.searchArray)")
                    
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                }
                self.tblSearchResult.reloadData()
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                self.tblSearchResult.reloadData()
            }
            BasicStuff.dismissLoader()
        }
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if self.SearchResultView.isHidden == false {
//            return self.SearchResultSection.count
//        }
        
        if isSearchEnable == true {
            var numOfSections: Int = 0
            if SearchResultSection.count != 0
            {
                numOfSections = SearchResultSection.count
                tableView.backgroundView = nil
            }
            else
            {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: -20, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = LocalizedString(key: "lbl_no_records_found")
                noDataLabel.font = UIFont(name: "Helvetica", size: 16)
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
            }
            return numOfSections
        }
        return isSearchEnable ? SearchResultSection.count : categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isSearchEnable == true {
            return 40
        }
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearchEnable == true {
            let SearchHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            SearchHeaderView.backgroundColor = UIColor.clear
            
            let lbl_Bg = UILabel.init(frame: CGRect(x: 0, y: 5, width: self.view.frame.size.width, height: 45))
            lbl_Bg.backgroundColor = UIColor.white
            SearchHeaderView.addSubview(lbl_Bg)
            
            
            let lbl_HeaderName = UILabel.init(frame: CGRect(x: 44, y: 5, width: self.view.frame.size.width - 44, height: 45))
            lbl_HeaderName.text = SearchResultSection[section]
            lbl_HeaderName.textColor = UIColor.init(hexString: "#2B2D2D")
            
//            lbl_HeaderName.backgroundColor = UIColor.white
            lbl_HeaderName.font = UIFont(name: "Helvetica-Bold", size: 18)
            SearchHeaderView.addSubview(lbl_HeaderName)
            return SearchHeaderView
        }
        else {
            let MainHeaderView = HeaderView(tableView: self.tblHomeSerch, section: section)
            MainHeaderView.headerDelegate = self
            MainHeaderView.backgroundColor = UIColor.init(hexString: "#F2F2F2")
            
            let getDataSection = categoryArray[section] as! NSDictionary
            
            MainHeaderView.lbl_HeaderName.font = UIFont(name: "Helvetica", size: 20)
            MainHeaderView.lbl_HeaderName.text = getDataSection.value(forKey: "super_category_name") as? String
            guard let IconImg = getDataSection.value(forKey: "icon_image") as? String  else {
                return MainHeaderView
            }
            MainHeaderView.Img_Header.sd_setImage(with: URL.init(string: IconImg), placeholderImage: UIImage.init(named: "ic_massage_category"))
            
            return MainHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable == true {
            return (searchArray[section] as! NSArray).count
        }
        if (self.tblHomeSerch.sectionOpen != NSNotFound && section == self.tblHomeSerch.sectionOpen) {
            if let getDataRow = (categoryArray[section] as! NSDictionary).value(forKey: "sub_category") as? NSArray {
                return getDataRow.count
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchEnable == false {
            let cell = self.tblHomeSerch.dequeueReusableCell(withIdentifier: "HomeSearchHeaderSubCell", for: indexPath) as! HomeSearchHeaderSubCell
            
            let dict = categoryArray[indexPath.section] as! NSDictionary
            
            if let subCategory = dict.value(forKeyPath: "sub_category") as? NSArray {
                cell.lbl_SubName.text = (subCategory[indexPath.row] as! NSDictionary).value(forKey: "sub_category_name") as? String
            }
            
            return cell
        }
        else {
            let cell = self.tblSearchResult.dequeueReusableCell(withIdentifier: "HomeSearchCell", for: indexPath) as! HomeSearchHeaderSubCell
            
            let DicData = (self.searchArray[indexPath.section] as! NSArray).object(at: indexPath.row) as! NSDictionary
            
            if let isService = DicData["name"] as? String {
                cell.lbl_ResultSubName.attributedText = self.generateAttributedString(with: txtSearch.text!, targetString: isService)
                cell.Img_Resultsubcell.image = UIImage(named: "")
            }
            else if let isBusiness = DicData["salon_name"] as? String {
                
                cell.lbl_ResultSubName.attributedText = self.generateAttributedString(with: txtSearch.text!, targetString: isBusiness)
                if let isIndividual = DicData["salon_type"] as? String {
                    if isIndividual == "1" {
                        cell.Img_Resultsubcell.image = UIImage(named: "ic_search_individual_home_page")
                    }
                    else {
                        cell.Img_Resultsubcell.image = UIImage(named: "ic_search_salon_home_page")
                    }
                }
            }
            else {
                cell.lbl_ResultSubName.text = ""
            }
            
            return cell
        }
    }
    
    //MARK:- UITableViewDelagete
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchEnable == true {
            
            let DicData = (self.searchArray[indexPath.section] as! NSArray).object(at: indexPath.row) as! NSDictionary
//            let isService = DicData["name"] ?? "isnotService"
            
            if let isService = DicData["sub_category_id"] as? String  {
                print("isService:=\(isService)")
                let salonlist = SalonListVC(nibName: "SalonListVC", bundle: nil)
                salonlist.getSubCategoryId = isService
                salonlist.flagView = "0"
                self.navigationController?.pushViewController(salonlist, animated: true)
            }
            else {
                print("isService:= nil")
            }
        }
        else {
            
            let dict = categoryArray[indexPath.section] as! NSDictionary
            var Selectedsub_category_id = String()
            if let subCategory = dict.value(forKeyPath: "sub_category") as? NSArray {
                Selectedsub_category_id = (subCategory[indexPath.row] as! NSDictionary).value(forKey: "sub_category_id") as! String
            }
            let salonlist = SalonListVC(nibName: "SalonListVC", bundle: nil)
            salonlist.getSubCategoryId = Selectedsub_category_id
            salonlist.flagView = "0"
            self.navigationController?.pushViewController(salonlist, animated: true)
        }
       
    }
    
    //MARK:-HeaderViewDelegate
    func headerView(_ headerView: HeaderView, didDelete section: Int) {
        
    }
   
    
 
    
    //    MARK:- TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(txtSearch.text?.isEmpty)! {
            isSearchEnable = true
            self.SearchResultSection.removeAll()
            self.searchArray.removeAllObjects()
            self.SearchResultView.isHidden = false
            self.getSearchList()
        }
        else {
           self.SearchResultView.isHidden = true
            isSearchEnable = false
            tblHomeSerch.reloadData()
        }
        return true
    }
    
//    MARK:- Custom Function
    func setLocalizedStaticText() {
        txtSearch.placeholder = LocalizedString(key: "txtPlace_SearchSalonProfessionistorService")
    }
    
    func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: targetString)
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hexString: "#2B2D2D"), range: match.range)
            }
            return attributedString
        } catch _ {
            NSLog("Error creating regular expresion")
            return nil
        }
    }
    
    //   MARK:- Button Action
    
    func btn_backAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func btn_FilterAction(_ sender:UIButton) {
        let filter = FilterVC(nibName: "FilterVC", bundle: nil)
        self.navigationController?.pushViewController(filter, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
