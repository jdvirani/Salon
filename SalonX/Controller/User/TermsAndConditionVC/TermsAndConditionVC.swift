//
//  TermsAndConditionVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var lbl_Titile: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    var isFromSalon = false
    
    var NavigationTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFromSalon {
            setupBackButton()
        } else {
            self.navigationController?.navigationBar.isHidden = false
            let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction))
            self.navigationItem.leftBarButtonItem  = buttonMenu
        }
        
        
        lbl_Description.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\n\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NavigationTitle
        self.lbl_Titile.text = LocalizedString(key: "lbl_TermsAndConditionsTitleName")
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
