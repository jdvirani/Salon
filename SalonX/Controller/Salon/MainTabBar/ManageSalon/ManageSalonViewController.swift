//
//  ManageSalonViewController.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

enum SalonType: Int {
    case individual = 0
    case organization
}

class ManageSalonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //var salonType: SalonType = .organization
    
    var btnNotification = MIBadgeButton()
    
    var manageOptions = [LocalizedString(key: "editSalonDetail"),
                         LocalizedString(key: "editExtraDetail"),
                         LocalizedString(key: "managePicture"),
                         LocalizedString(key: "manageService"),
                         LocalizedString(key: "manageEmployee"),
                         LocalizedString(key: "manageProgram"),
                         LocalizedString(key: "lastMinuteOffer")]
    
    convenience init() {
        self.init(nibName: R.nib.manageSalonVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeUI()
        
        setUpTableUI()
        
        setupBarButton()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "manageSalon")
    }
    
    func setupBarButton() {
        
        btnNotification.titleLabel?.font = UIFont.fontAwesome(ofSize: 24)
        btnNotification.setTitle("\(String.fontAwesomeIcon(name: .bell))", for: .normal)
        btnNotification.frame = CGRect(x: 0, y: 0, width: 45, height: 20)
        btnNotification.setTitleColor(R.color.salonX.seperator(), for: .normal)
        btnNotification.addTarget(self, action: #selector(ManageSalonViewController.notificaitionBtnTapped(_:)), for: .touchUpInside)
        btnNotification.badgeTextColor = UIColor.white
        btnNotification.badgeBackgroundColor = UIColor.red
        btnNotification.badgeEdgeInsets = UIEdgeInsetsMake(7, 0, 0, 15)
        
        let btnNotificationItem = UIBarButtonItem()
        btnNotificationItem.customView = btnNotification
        navigationItem.leftBarButtonItems = [btnNotificationItem]
        btnNotification.badgeString = "3"
    }
    
    func setUpTableUI() {
        tableView.register(R.nib.manageOptionCell(), forCellReuseIdentifier: "cell")
//        tableView.estimatedRowHeight = 76.0
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    func notificaitionBtnTapped(_ sender: UIBarButtonItem) {
        print("notification Tapped")
        btnNotification.badgeString = ""
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
}


extension ManageSalonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ManageOptionsTableViewCell
        
        cell.selectionStyle = .none
        
        cell.lblOptionName.text = manageOptions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(EditSalonDetailViewController(), animated: true)
            
        case 1:
            navigationController?.pushViewController(EditExtraDetailViewController(), animated: true)
            
        case 2:
            navigationController?.pushViewController(ManagePicturesViewController(), animated: true)
            
        case 3:
            navigationController?.pushViewController(ManageServiceViewController(), animated: true)
            
        case 4:
            navigationController?.pushViewController(ManageEmployeeViewController(), animated: true)
            
        case 5:
            navigationController?.pushViewController(ManageProgramViewController(), animated: true)
            
        case 6:
            navigationController?.pushViewController(LastMinuteOfferListViewController(), animated: true)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
        CGFloat {
            
            if isIndividualUser() {
                if indexPath.row == 4 {
                    return 0
                }
                return (UIScreen.main.bounds.height - 44) / 6
            } else {
                return (UIScreen.main.bounds.height - 44) / 7
                
            }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if isIndividualUser() {
            if indexPath.row == 4 {
                return 0
            }
            return (UIScreen.main.bounds.height - 44) / 6
        } else {
            return (UIScreen.main.bounds.height - 44) / 7
            
        }
    }
    
}
