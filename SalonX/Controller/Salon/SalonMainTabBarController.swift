//
//  SalonMainTabBarController.swift
//  SalonX
//
//  Created by DK on 10/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class SalonMainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = LocalizedString(key: "manageSalon")
        //navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO:- Change View Controllers
         let vc1 = UINavigationController(rootViewController: SalonDashboardViewController())
        let vc2 = UINavigationController(rootViewController: ManageSalonViewController())
        
        let vc3 = UINavigationController(rootViewController: AddAppointmentViewController())
        
        let vc4 = UINavigationController(rootViewController: ReportViewController())
        let vc5 = UINavigationController(rootViewController: SalonClientListViewController())
        vc5.topViewController?.title = LocalizedString(key: "clients")
        
         viewControllers = [vc1,vc2,vc3,vc4,vc5]
        
        tabBar.barTintColor = R.color.salonX.headerBG()
        tabBar.tintColor = R.color.salonX.headerBG()
        
        tabBar.items?[0].title = LocalizedString(key: "dashboard")
        tabBar.items?[1].title = LocalizedString(key: "manageSalon")
        tabBar.items?[2].title = LocalizedString(key: "agenda")
        tabBar.items?[3].title = LocalizedString(key: "report")
        tabBar.items?[4].title = LocalizedString(key: "client")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont(name: "Arial", size: 9)!], for:.normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: R.color.salonX.accent()], for:.selected)
        
        tabBar.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(color: R.color.salonX.tabSelected(), size: CGSize(width: tabBar.frame.width/5, height: tabBar.frame.height))

        tabBar.items?[0].selectedImage = R.image.ic_home_selected()?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[0].image = R.image.ic_home_unselected()?.withRenderingMode(.alwaysOriginal)

        tabBar.items?[1].image = R.image.ic_manageSalon_unselected()?.withRenderingMode(.alwaysOriginal)

        tabBar.items?[1].selectedImage = R.image.ic_manageSalon_selected()?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[2].image = R.image.ic_agenda_unselected()?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[2].selectedImage = R.image.ic_agenda_selected()?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[3].image = R.image.ic_report_unselected()?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[3].selectedImage = R.image.ic_report_selected()?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[4].image = R.image.ic_client_unselected()?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[4].selectedImage = R.image.ic_client_selected()?.withRenderingMode(.alwaysOriginal)
    }
}

extension SalonMainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    
}
