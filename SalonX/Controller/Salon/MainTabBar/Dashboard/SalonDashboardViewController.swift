//
//  SalonDashboardViewController.swift
//  SalonX
//
//  Created by DK on 10/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MIBadgeButton_Swift

class SalonDashboardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblAgenda: UILabel!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblClient: UILabel!
    @IBOutlet weak var lblReports: UILabel!
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var lblPayments: UILabel!

    var btnNotification = MIBadgeButton()
    var optionImages: [UIImage] = [R.image.ic_agenda_dashboard()!,R.image.ic_profile_dashboard()!,R.image.ic_client_dashboard()!,R.image.ic_report_dashboard()!,R.image.ic_setting_dashboard()!,R.image.ic_payment_dashboard()!]
    
    var optionNames: [String] = [LocalizedString(key: "agenda"),LocalizedString(key: "profile"),LocalizedString(key: "client"),LocalizedString(key: "reports"),LocalizedString(key: "setting"),LocalizedString(key: "payment")]
    
    //Load XIB
    convenience init() {
        self.init(nibName: R.nib.salonDashboard.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        setupBarButton()
        localizeUI()
        setupCollectionViewUI()
    }
    
    func setupCollectionViewUI() {
        collectionView.register(R.nib.dashbaordCell(), forCellWithReuseIdentifier: "cell")
    }
    
    
    func setupBarButton() {
        
        btnNotification.titleLabel?.font = UIFont.fontAwesome(ofSize: 24)
        btnNotification.setTitle("\(String.fontAwesomeIcon(name: .bell))", for: .normal)
        btnNotification.frame = CGRect(x: 0, y: 0, width: 45, height: 20)
        btnNotification.setTitleColor(R.color.salonX.seperator(), for: .normal)
        btnNotification.addTarget(self, action: #selector(SalonDashboardViewController.notificaitionBtnTapped(_:)), for: .touchUpInside)
        btnNotification.badgeTextColor = UIColor.white
        btnNotification.badgeBackgroundColor = UIColor.red
        btnNotification.badgeEdgeInsets = UIEdgeInsetsMake(7, 0, 0, 15)
        
        let btnNotificationItem = UIBarButtonItem()
        btnNotificationItem.customView = btnNotification
        navigationItem.leftBarButtonItems = [btnNotificationItem]
        btnNotification.badgeString = "7"
    }
    
    func localizeUI() {
        
        self.title = LocalizedString(key: "dashboard")
        lblAgenda.text = LocalizedString(key: "agenda")
        lblProfile.text = LocalizedString(key: "profile")
        lblClient.text = LocalizedString(key: "client")
        lblReports.text = LocalizedString(key: "reports")
        lblSetting.text = LocalizedString(key: "setting")
        lblPayments.text = LocalizedString(key: "payment")
    }
}

extension SalonDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCollectionViewCell
        
        cell.imgOption.image = optionImages[indexPath.row]
        cell.lblOptionName.text = optionNames[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.tabBarController?.selectedIndex = 2
        
        case 1:
            self.tabBarController?.selectedIndex = 1

        case 2:
            self.tabBarController?.selectedIndex = 4

        case 3:
            self.tabBarController?.selectedIndex = 3
            
        case 4:
            let settingVC = R.storyboard.main.settingVC()
            navigationController?.pushViewController(settingVC!, animated: true)
            
        case 5:
            break
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: ((collectionView.frame.size.width / 2) - 8), height: ((collectionView.frame.size.width / 2) - 8))
    }
}


//MARK: - Actions
extension SalonDashboardViewController {
    
    func notificaitionBtnTapped(_ sender: UIBarButtonItem) {
            btnNotification.badgeString = ""
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    @IBAction func viewAgendaTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func viewProfileTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func viewClientTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 4
    }
    
    @IBAction func viewReportTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func viewSettingTapped(_ sender: UIButton) {
        
        let settingVC = R.storyboard.main.settingVC()
        navigationController?.pushViewController(settingVC!, animated: true)
    }
    
    @IBAction func viewPaymentTapped(_ sender: UIButton) {
        
    }
    
    
}
