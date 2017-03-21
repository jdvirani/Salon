//
//  LeftMenuVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var Img_User: UIImageView!
    @IBOutlet weak var HeaderSignupView: UIView!
    @IBOutlet weak var btn_SignUp: UIButton!
     @IBOutlet weak var tblLeftMenu: UITableView!
    
    var mainViewController: UIViewController!
    var navigationVC:UINavigationController =  UINavigationController()
    
    var SectionTitleArray = [LocalizedString(key: "lbl_Salon"),LocalizedString(key: "lbl_Profile"),LocalizedString(key: "lbl_Other")]
    var Row1TitleArray = [LocalizedString(key:"lbl_FindSalonService"),LocalizedString(key:"lbl_lastMintOffer")]
    var Row2TitleArray = [LocalizedString(key:"lbl_MyProfile"),LocalizedString(key:"lbl_MyAppointment"),LocalizedString(key:"lbl_MyFavoriteSalon")]
    var Row3TitleArray = [LocalizedString(key:"lbl_TermsConditions"),LocalizedString(key:"lbl_PrivacyPolicy"),LocalizedString(key:"lbl_Contact")]
    
    var ImagesRow1Array = ["ic_search_sidemenu_unselected","ic_last_minute_offer_side_menu_unselect"]
    var ImagesRow1ArraySelected = ["ic_search_sidemenu_selected","ic_last_minute_offer_side_menu_select"]
    var ImagesRow2Array = ["ic_my_profile_side_menu_unselected","ic_my_appointment_side_menu_unselected","ic_favorite_side_menu_unselected"]
    var ImagesRow2ArraySelected = ["ic_my_profile_side_menu_selected","ic_my_appointment_side_menu_selected","ic_favorite_side_menu_selected"]
    var ImagesRow3Array = ["ic_term_and_condition_side_menu_unselected","ic_privacy_policy_side_menu_unselected","ic_contact_side_menu_unselected"]
    var ImagesRow3ArraySelected = ["ic_term_and_condition_side_menu_selected","ic_privacy_policy_side_menu_selected","ic_contact_side_menu_selected"]
   
    var getuserid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nibName = UINib(nibName: "LeftMenuCell", bundle:nil)
        self.tblLeftMenu.register(nibName, forCellReuseIdentifier: "LeftMenuCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Left menu view will appear called")
        
        getuserid = BasicStuff.getClienDetailWithoutCerdential(Key_IsLogin)
        
        if  getuserid != "0" {
            self.HeaderSignupView.isHidden = true
            lbl_UserName.text = BasicStuff.getClienDetailWithoutCerdential("first_name") + " " + BasicStuff.getClienDetailWithoutCerdential("last_name")
            let getImg = BasicStuff.getClienDetailWithoutCerdential("user_profile_pic")
            Img_User.sd_setImage(with: URL.init(string: getImg), placeholderImage: UIImage.init(named: "user_placeholder_side_menu"))
        }
        else {
            self.HeaderSignupView.isHidden = false
        }
        
    }
    
//    MARK:- Tableview Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTitleArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let MainSectionView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
        MainSectionView.backgroundColor = UIColor.clear
        let lbl_Title = UILabel(frame: CGRect(x: 16, y: 3, width: MainSectionView.frame.size.width - 32, height: 30))
        lbl_Title.text = SectionTitleArray[section]
        lbl_Title.textColor = UIColor.init(hexString: "#049FCF")
        lbl_Title.font = UIFont(name: "Helvetica", size: 18)
        MainSectionView.addSubview(lbl_Title)
        return MainSectionView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section:=\(section)")
        if section == 0 {
            return Row1TitleArray.count
        }
        else if section == 1 {
            return Row2TitleArray.count
        }
        else {
            return Row3TitleArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.Section:=\(indexPath.section)")
        print("indexPath.row:=\(indexPath.row)")
        let cell = tblLeftMenu.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        let SelectedSection = BasicStuff.basic.setLeftMenuSelected["section"] as! Int
        let SelectedIndexPath = BasicStuff.basic.setLeftMenuSelected["indexpath"] as! Int
        
        if indexPath.section == 0 {
            cell.lbl_MenuTitle.text = Row1TitleArray[indexPath.row]
            if SelectedSection == indexPath.section {
                cell.lbl_MenuTitle.textColor = UIColor.init(hexString: "#049FCF")
                if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow1ArraySelected[indexPath.row])
                }
                else if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow1ArraySelected[indexPath.row])
                }
                else if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow1ArraySelected[indexPath.row])
                }
                else {
                    cell.lbl_MenuTitle.text = Row1TitleArray[indexPath.row]
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow1Array[indexPath.row])
                    cell.lbl_MenuTitle.textColor = UIColor.white
                }
            }else {
//                cell.lbl_MenuTitle.text = Row1TitleArray[indexPath.row]
                cell.Img_MenuIcon.image = UIImage(named: ImagesRow1Array[indexPath.row])
                cell.lbl_MenuTitle.textColor = UIColor.white
            }
            
            
        }
        else if indexPath.section == 1 {
            cell.lbl_MenuTitle.text = Row2TitleArray[indexPath.row]

            if SelectedSection == indexPath.section {
                cell.lbl_MenuTitle.textColor = UIColor.init(hexString: "#049FCF")
                if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow2ArraySelected[indexPath.row])
                }
                else if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow2ArraySelected[indexPath.row])
                }
                else if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow2ArraySelected[indexPath.row])
                }
                else {
                    cell.lbl_MenuTitle.text = Row2TitleArray[indexPath.row]
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow2Array[indexPath.row])
                    cell.lbl_MenuTitle.textColor = UIColor.white
                }
            }else {
                
                cell.lbl_MenuTitle.textColor = UIColor.white
//                cell.lbl_MenuTitle.text = Row2TitleArray[indexPath.row]
                cell.Img_MenuIcon.image = UIImage(named: ImagesRow2Array[indexPath.row])
            }
        }
        else {
            cell.lbl_MenuTitle.text = Row3TitleArray[indexPath.row]
            
           if SelectedSection == indexPath.section {
            
                cell.lbl_MenuTitle.textColor = UIColor.init(hexString: "#049FCF")
                if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow3ArraySelected[indexPath.row])
                }
                else if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow3ArraySelected[indexPath.row])
                }
                else if SelectedIndexPath == indexPath.row {
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow3ArraySelected[indexPath.row])
                }
                else {
//                    cell.lbl_MenuTitle.text = Row3TitleArray[indexPath.row]
                    cell.Img_MenuIcon.image = UIImage(named: ImagesRow3Array[indexPath.row])
                    cell.lbl_MenuTitle.textColor = UIColor.white
                }
            }else {
                
                cell.lbl_MenuTitle.textColor = UIColor.white
//                cell.lbl_MenuTitle.text = Row3TitleArray[indexPath.row]
                cell.Img_MenuIcon.image = UIImage(named: ImagesRow3Array[indexPath.row])
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        BasicStuff.basic.setLeftMenuSelected = ["section":indexPath.section,"indexpath":indexPath.row]
        tblLeftMenu.reloadData()
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                navigationVC = UINavigationController (rootViewController:Home)
                navigationVC.navigationBar.isHidden = false
                self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            }
            else {
                let LastMintOffer = LastMintOfferVC(nibName: "LastMintOfferVC", bundle: nil)
                LastMintOffer.IsBackArrow = "No"
                navigationVC = UINavigationController (rootViewController:LastMintOffer)
                navigationVC.navigationBar.isHidden = false
                self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            }
        }
        else if indexPath.section == 1 {

            if indexPath.row == 0 {
//                let ClientData = BasicStuff.getClienDetailWithoutCerdential(Key_IsLogin)
                if getuserid == "0" {
                    let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                    navigationVC = UINavigationController (rootViewController:Home)
                    navigationVC.navigationBar.isHidden = false
                    self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                }
                else {
                    let Profile = MyProfileVC(nibName: "MyProfileVC", bundle: nil)
                    navigationVC = UINavigationController (rootViewController:Profile)
                    navigationVC.navigationBar.isHidden = false
                    self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                }
            }
            else if indexPath.row == 1 {
                if getuserid == "0" {
                    let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                    navigationVC = UINavigationController (rootViewController:Home)
                    navigationVC.navigationBar.isHidden = false
                    self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                }else {
                    let MyAppointmnet = MyAppointmentVC(nibName: "MyAppointmentVC", bundle: nil)
                    navigationVC = UINavigationController (rootViewController:MyAppointmnet)
                    navigationVC.navigationBar.isHidden = false
                    self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                }
                
            }
            else {
                let FavoriteSalon = MyFavoriteSalon(nibName: "MyFavoriteSalon", bundle: nil)
                navigationVC = UINavigationController (rootViewController:FavoriteSalon)
                navigationVC.navigationBar.isHidden = false
                self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            }
        }
        else {

            if indexPath.row == 0 {
                let TermCondition = TermsAndConditionVC(nibName: "TermsAndConditionVC", bundle: nil)
                TermCondition.NavigationTitle = LocalizedString(key: "lbl_TermsAndConditionsHeader")
                navigationVC = UINavigationController (rootViewController:TermCondition)
                navigationVC.navigationBar.isHidden = false
                self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                
            }
            else if indexPath.row == 1 {
                let TermCondition = TermsAndConditionVC(nibName: "TermsAndConditionVC", bundle: nil)
                TermCondition.NavigationTitle = LocalizedString(key: "lbl_PrivacyPolicyHeader")
                navigationVC = UINavigationController (rootViewController:TermCondition)
                navigationVC.navigationBar.isHidden = false
                self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            }
            else {
                if getuserid == "0" {
                    let Home = HomeVC(nibName: "HomeVC", bundle: nil)
                    navigationVC = UINavigationController (rootViewController:Home)
                    navigationVC.navigationBar.isHidden = false
                    self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                }else {
                    let Contact = Contactus(nibName: "Contactus", bundle: nil)
                    navigationVC = UINavigationController (rootViewController:Contact)
                    navigationVC.navigationBar.isHidden = false
                    self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
                }
            }
        }
    }
    
        
//    MARK:- Button Action
    @IBAction func btn_SignUpAction(_ sender:UIButton) {
        if getuserid == "0" {
            let vc = LoginViewController()
            let navVC = UINavigationController(rootViewController: vc)
            appDelegate.configureWindowAndMakeVisible(rootVC: navVC)
        }
        else {
            LogoutClient()
            print(BasicStuff.getClienDetailWithoutCerdential("user_id"))

        }
    }
    
    func LogoutClient() {
        
        let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "areYouSureToLogout"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizedString(key: "ok"), style: .default, handler: { (action) in
           // BasicStuff.showLoader(self.view)
            
            let userId =  BasicStuff.getClienDetailWithoutCerdential("user_id")
            let accessToken = BasicStuff.getClienDetailWithoutCerdential("access_token")
            
            let param = ["user_id" : userId,
                         "access_token" : accessToken,
                         "device_token" : "987654321645655",
                         "user_type" : "0",
                         "lang" : Language.shared.Lang]

            if Rechability.isConnectedToNetwork() {
                
                BasicStuff.showLoader(self.view)
                LogoutService().logoutRequest(param: param, completion: { (result) in
                    print(result.value)
                    BasicStuff.dismissLoader()
                    if let json = result.value {
                        if json[R.string.keys.flag()].stringValue == "1" {
                            
                            BasicStuff.removeClienDetailWithoutCerdential()
                            let vc = UINavigationController(rootViewController: LoginViewController())
                            appDelegate.configureWindowAndMakeVisible(rootVC: vc)
                        } else if json[R.string.keys.flag()].stringValue == "0" {
                            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json["msg"].stringValue)
                        }
                    }
                })
                
            } else {
                BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
            }
        })
        
        let cancelAction = UIAlertAction(title: LocalizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
