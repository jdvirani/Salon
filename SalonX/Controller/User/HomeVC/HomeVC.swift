//
//  HomeVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    

    
    var HomeListData:NSDictionary?
    var HomeListArrray:NSMutableArray!
    var SliderListArray:[String]!
    var Selectedsub_category_id:String!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        HomeListArrray = NSMutableArray()
        SliderListArray = [String]()
        
        self.navigationController?.navigationBar.isHidden = false
        
        //TODO: - Temporary code
//        let btn1 = UIButton(type: .custom)
//        btn1.setImage(UIImage(named: "ic_menubar_header"), for: .normal)
//        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        btn1.addTarget(self, action: #selector(self.btn_LeftMenuAction), for: .touchUpInside)
//        let item1 = UIBarButtonItem(customView: btn1)
//        
//        navigationItem.leftBarButtonItem = item1
        
        let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction)) // action:#selector(Class.MethodName) for swift 3
        buttonMenu.tintColor = UIColor.white
//        buttonMenu.setTitleTextAttributes([ NSFontAttributeName : UIFont(name: "Helvetica", size: 17.0)!, NSForegroundColorAttributeName : UIColor.white ], for: .normal)
        self.navigationItem.leftBarButtonItem  = buttonMenu
        
        let HeaderView = UIButton.init(frame: CGRect(x: 0, y: -20, width: 42, height: 22))
        
        HeaderView.isUserInteractionEnabled = false
        HeaderView.setBackgroundImage(UIImage(named: "logo_header"), for: .normal)
        self.navigationItem.titleView = HeaderView
        
        let HomeHederNib = UINib(nibName: "HomeHeaderCell", bundle: nil)
        tblHome.register(HomeHederNib, forCellReuseIdentifier: "HomeHeaderCell")
        
        let HomeNib = UINib(nibName: "HomeCell", bundle: nil)
        tblHome.register(HomeNib, forCellReuseIdentifier: "HomeCell")
        
        let getuserid = BasicStuff.getClienDetailWithoutCerdential(Key_IsLogin)
        
        if !getuserid.isEmpty{
 
           self.getHomeList()
            
        } else {

            generate_user_accesstoken()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalizedStaticText()
        tblHome.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if SliderListArray.count != 0 {
            let indexpath = IndexPath.init(row: 0, section: 0)
            if let cell = tblHome.cellForRow(at: indexpath) as? HomeCell {
                cell.image_Pager.slideshowTimeInterval = UInt(0.0)
            }
        }
    }
    
    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeListArrray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblHome.dequeueReusableCell(withIdentifier: "HomeHeaderCell") as! HomeCell
            cell.lbl_welcome.text = LocalizedString(key: "lbl_welcome")
            if SliderListArray.count != 0 {
                cell.setImagePagerConfigure(arraySlider:SliderListArray)
            }
            return cell
        }
        else {
            let cell = tblHome.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
            let dicData = HomeListArrray.object(at: indexPath.row) as! NSDictionary
            if let getsuper_category_name = dicData["super_category_name"] as? String {
                cell.lbl_Title.text = getsuper_category_name
                guard let mobile_image = dicData.value(forKey: "mobile_image") as? String else {
                    return cell
                }
                cell.Img_Home.sd_setImage(with: URL.init(string:mobile_image), placeholderImage: UIImage.init(named: "placeholder_listing_salon"))
            }
            else {
                cell.lbl_Title.text = dicData.value(forKey: "title") as? String
                guard let mobile_image = dicData.value(forKey: "mobile_image") as? String else {
                    return cell
                }
                cell.Img_Home.sd_setImage(with: URL.init(string:mobile_image), placeholderImage: UIImage.init(named: "placeholder_listing_salon"))
            }
                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexPath:=\(indexPath.section),indexPath.Row:=\(indexPath.row)")
        if indexPath.row == 0 {
            let cell = tblHome.dequeueReusableCell(withIdentifier: "HomeHeaderCell") as! HomeCell
            cell.image_Pager.slideshowTimeInterval = UInt(0.0)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }
        else {
            let dicData = HomeListArrray.object(at: indexPath.row) as! NSDictionary
            print("dicData:=\(dicData)")
            
            if let getsuper_category_name = dicData["super_category_name"] as? String {
                if let getsub_category = dicData["sub_category"] as? NSArray  {
                    let CustomPopHome = CustomPopHomeVC(nibName: "CustomPopHomeVC", bundle: nil)
                    CustomPopHome.Home = self
                    CustomPopHome.modalPresentationStyle = .overCurrentContext
                    CustomPopHome.HomePopDataArray = getsub_category
                    self.present(CustomPopHome, animated: true, completion: nil)
                }
            }
            else if let offer_id1 = dicData["offer_id"] as? Int {
                let lastmintOffer = LastMintOfferVC(nibName: "LastMintOfferVC", bundle: nil)
                lastmintOffer.IsBackArrow = "Yes"
                self.navigationController?.pushViewController(lastmintOffer, animated: true)
            }
            else {
                let salonlist = SalonListVC(nibName: "SalonListVC", bundle: nil)
                salonlist.flagView = "2" // Available today
                self.navigationController?.pushViewController(salonlist, animated: true)
            }
        }

    }
    
//    MARK:- Custom function
    func getHomeList() {
       
        let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
        let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
        
        BasicStuff.showLoader(self.view)
        var sendDict = NSDictionary()
        sendDict = ["lang":Language.shared.Lang,"access_token":getAccestokenwithOutCredential,"user_id":getUserIDwithOutCredential]
        
        let manager = ServiceCall(URL:API_HomeList)
        manager.setContentType(contentType: .multiPartForm)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.POST(parameters: sendDict) { (success:Bool, responceObj:Any) in
            
            SalonLog("responceObj:===>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
//                    let getData = Obj.value(forKey: "data") as! NSDictionary
                    self.HomeListData = Obj.value(forKey: "data") as? NSDictionary
                    self.HomeListArrray.add(self.HomeListData?["slider"] as! NSArray)
                    if let getSliderArray = self.HomeListData?["slider"] as? NSArray {
                        for i in 0..<getSliderArray.count {
                            let dicData = getSliderArray[i] as! NSDictionary
                            self.SliderListArray.append(dicData.value(forKey: "slider_image") as! String)
                        }
                        print("SliderListArray:=\(self.SliderListArray!)")
                    }
                    if let arrayCateory = self.HomeListData?["category"] as? [NSDictionary] {
                        for i in 0..<arrayCateory.count {
                            self.HomeListArrray.add(arrayCateory[i])
                        }
                        print("HomeListArrray:=\(self.HomeListArrray!)")
                        self.tblHome.reloadData()
                    }

                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                }
                
            }
            else {
                 BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
            BasicStuff.dismissLoader()
        }
        
        
    }
    
    func setLocalizedStaticText() {
        txtSearch.placeholder = LocalizedString(key: "txtPlace_SearchSalonProfessionistorService")
    }
    
    func generate_user_accesstoken() {
        let deviceToken = String.random()
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue("1", forKey: "device_type")
        sendDict.setValue("", forKey: "register_id")
        sendDict.setValue(deviceToken, forKey: "device_token")
        
        let manager = ServiceCall(URL: API_Generate_AccessToken)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        
        BasicStuff.showLoader(self.view)
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            BasicStuff.dismissLoader()
            if success {
                let Obj = (responceObj as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                    Obj.removeObject(forKey: "flag")
                    Obj.setValue("0", forKey: Key_IsLogin)
                    BasicStuff.saveClienDetailWithoutCerdential(Obj)
                    self.getHomeList()
                }
                else {
                    self.generate_user_accesstoken()
                }
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
        }
        
    }
    
    func CustomPopHomeSelectedData(SelectedData:NSDictionary) {
        print("SelectedData:=\(SelectedData)")
        self.dismiss(animated: true, completion: nil)
        Selectedsub_category_id = SelectedData["sub_category_id"] as! String
        print("Selectedsub_category_id:=\(Selectedsub_category_id!)")
        self.perform(#selector(self.PushToSalonListController), with: nil, afterDelay: 0.5)
       
        
    }
    func PushToSalonListController() {
        let salonlist = SalonListVC(nibName: "SalonListVC", bundle: nil)
        salonlist.getSubCategoryId = Selectedsub_category_id
        salonlist.flagView = "0"
        self.navigationController?.pushViewController(salonlist, animated: true)
    }
    
    
//    MARK:- TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let search = HomeSearchVC(nibName: "HomeSearchVC", bundle: nil)
        if HomeListData?.count != 0 {
            search.getHomeData = HomeListData
        }
        self.navigationController?.pushViewController(search, animated: true)
        
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//   MARK:- LeftMenu Action
    func btn_LeftMenuAction(_ sender: UIButton) {
        let sideMenuController = slideMenuController()
        sideMenuController?.openLeft()
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
