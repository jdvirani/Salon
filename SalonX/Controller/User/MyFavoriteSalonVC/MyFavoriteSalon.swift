//
//  MyFavoriteSalon.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/18/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class MyFavoriteSalon: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblMyFavoriteSalon: UITableView!
    
    var FavoriteArray = NSMutableArray()
    var flag:NSNumber = 0
    let refreshControl = UIRefreshControl()
    
    let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
    let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction)) 
        self.navigationItem.leftBarButtonItem  = buttonMenu
        buttonMenu.tintColor = UIColor.white
//        self.navigationController?.navigationBar.topItem?.title = "Favorite Salon"
        
        let nibName = UINib(nibName: "MyFavoriteCell", bundle: nil)
        tblMyFavoriteSalon.register(nibName, forCellReuseIdentifier: "MyFavoriteCell")
        
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        self.tblMyFavoriteSalon.bottomRefreshControl = refreshControl
        
//        tblMyFavoriteSalon.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_FavoriteSalonHeader")
        FavoriteArray.removeAllObjects()
        flag = 0
        self.refreshTable()
    }
    func refreshTable(){
        refreshControl.beginRefreshing()
        self.getFavoriteList()
    }
    
//    MARK:- Custom Function
    func getFavoriteList()  {
        if flag.intValue >= 0 {
            
            BasicStuff.showLoader(self.view)
            let sendDict = NSMutableDictionary()
            sendDict.setValue("1", forKey: "flag_view") // for Favorite List
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(flag.stringValue, forKey: "offset")
            sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
            sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
            
            let manager = ServiceCall(URL: API_SalonList)
            manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
            manager.setContentType(contentType: .multiPartForm)
            
            
            manager.POST(parameters: sendDict) { (success, responceObj) in
                
                SalonLog("responceObj:====>\(responceObj)")
                self.refreshControl.endRefreshing()
                
                if success {
                    let Obj = responceObj as! NSDictionary
                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    if flag == 1 {
                        self.flag = Obj.value(forKey: "next_offset") as! NSNumber
                        let arrayOffer = Obj.value(forKey: "data") as! NSArray
                        for r in 0..<arrayOffer.count {
                            let DicData = arrayOffer[r] as! NSDictionary
                            self.FavoriteArray.add(DicData)
                        }
                        print("FavoriteArray:=\(self.FavoriteArray)")
                        self.tblMyFavoriteSalon.reloadData()
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
            
        }else {
            refreshControl.endRefreshing()
        }
    }
    
    
//  MARK:- Tabelview Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if FavoriteArray.count != 0
        {
            numOfSections = 1
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblMyFavoriteSalon.dequeueReusableCell(withIdentifier: "MyFavoriteCell") as! MyFavoriteCell
        let DicData = FavoriteArray[indexPath.row] as! NSDictionary
        cell.lbl_Style.text = DicData["profession_name"] as? String
        if let salon_image = DicData["salon_image"] as? String {
            cell.Img_Salon.sd_setImage(with: URL.init(string: salon_image), placeholderImage: UIImage.init(named: "placeholder_listing_salon"))
        }
        if let rateTotal = DicData["rat_total"] as? String {
            cell.lbl_Review.text = "(\(rateTotal))"
        }else {
            cell.lbl_Review.text = "(0)"
        }
        cell.lbl_Address.text = DicData["address"] as? String
        if let rate = DicData["rat_avg"] as? NSString {
            let getFloat:Float = rate.floatValue/10
            cell.lbl_Ratingview.setScore(getFloat, withAnimation: false)
        }
        cell.btn_Favorite.isSelected = true
        cell.btn_Favorite.isHidden = false
        cell.lbl_BottmBorder.isHidden = false
        cell.lbl_Name.text = DicData["salon_name"] as? String
        cell.btn_Favorite.accessibilityElements = [indexPath]
        cell.btn_Favorite.addTarget(self, action: #selector(btn_FavoriteAction(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DicData = FavoriteArray[indexPath.row] as! NSDictionary
        let SalonDetail = SalonDetailVC(nibName: "SalonDetailVC", bundle: nil)
        SalonDetail.salon_id = DicData["salon_id"] as? String
        self.navigationController?.pushViewController(SalonDetail, animated: true)
    }
    
    
//    MARK:- Button Action
    func btn_FavoriteAction(_ sender:UIButton) {
        print("Favorite Click @ index:=\(sender.tag)")
        let indexpath = sender.accessibilityElements?.first as! IndexPath
       
        
        let DicData = FavoriteArray[indexpath.row] as! NSDictionary
        let salon_id = DicData["salon_id"] as? String
        
            BasicStuff.showLoader(self.view)
            let sendDict = NSMutableDictionary()
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(salon_id, forKey: "salon_id")
            sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
            sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
            
            let manager = ServiceCall(URL: API_SalonFavorite)
            manager.setContentType(contentType: .multiPartForm)
            manager.setAuthorization(username: AUTHUSERNAME, password:AUTHPASSWORD)
            
            manager.POST(parameters: sendDict) { (success, responceObj) in
                
                SalonLog("responceObj:====>\(responceObj)")
                BasicStuff.dismissLoader()
                
                if success {
                    let Obj = responceObj as! NSDictionary
                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    if flag == 1 {
                        BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                        self.FavoriteArray.removeObject(at: indexpath.row)
                        self.tblMyFavoriteSalon.reloadData()
                    }
                    else {
                        BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    }
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                }
            }
      
        
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
