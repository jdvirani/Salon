//
//  AppDelegate.swift
//  SalonX
//
//  Created by DK on 09/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import Material
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainNavigation:UINavigationController!
    static let shared:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let device_id = UIDevice.current.identifierForVendor?.uuidString
        print("UDID is \(device_id)")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let CurrentLanguage = NSLocale.current.languageCode
        if CurrentLanguage == "en" {
            print("this is English")
            Language.shared.set(lang: .English)
        } else if CurrentLanguage == "ro" {
            print("this is Rominia")
            Language.shared.set(lang: .Romanian)
        }
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,
                                                            NSFontAttributeName: UIFont(name: "Helvetica", size: 18.0)!]
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = R.color.salonX.headerBG()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().backgroundColor = R.color.salonX.headerBG()
        
        setStatusBarBackgroundColor(color: UIColor.black)
        
        // If Salon use is Logged in then redirect to Salon otherwise redirect to User home screen.
        if UserDefaults.standard.bool(forKey: R.string.keys.isUserSignIn()) {
            
            configureWindowAndMakeVisible(rootVC: SalonMainTabBarController())
   
        } else {
            let slideMenuController = setSideMenu()
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
            return true
        }
  
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handler:Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handler
    }
    
    func setSideMenu() -> SlideMenuController {
        let MainViewController1 = HomeVC(nibName: "HomeVC", bundle: nil)
        
        let leftViewController = LeftMenuVC(nibName: "LeftMenuVC", bundle: nil)
        mainNavigation = UINavigationController(rootViewController: MainViewController1)
        leftViewController.mainViewController = mainNavigation
        mainNavigation.navigationBar.isHidden = true
        
        let slideMenuController = SlideMenuController(mainViewController: mainNavigation, leftMenuViewController: leftViewController)
        
        slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width - 110)
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.shadowRadius = 0.5
        SlideMenuOptions.shadowOpacity = 0.2
        SlideMenuOptions.contentViewOpacity = 0.6
        SlideMenuOptions.hideStatusBar = false
        
        return slideMenuController
    }
    
    func generate_user_accesstoken(RootController:SlideMenuController) {
        let deviceToken = String.random()
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue("1", forKey: "device_type")
        sendDict.setValue("", forKey: "register_id")
        sendDict.setValue(deviceToken, forKey: "device_token")
        
        let manager = ServiceCall(URL: API_Generate_AccessToken)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = (responceObj as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                    Obj.removeObject(forKey: "flag")
                    Obj.setValue("0", forKey: Key_IsLogin)
                    BasicStuff.saveClienDetailWithoutCerdential(Obj)
                    self.window?.rootViewController = RootController
                    self.window?.makeKeyAndVisible()
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey:"msg") as! String)
                }
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
        }
        
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
        
    }
    
    //    func redirectToSignupVC() {
    //
    //        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,
    //                                                            NSFontAttributeName: UIFont(name: "Helvetica", size: 18.0)!]
    //
    //        UINavigationBar.appearance().barTintColor = R.color.salonX.headerBG()
    //        UINavigationBar.appearance().tintColor = UIColor.white
    //        UINavigationBar.appearance().backgroundColor = R.color.salonX.headerBG()
    //
    //        if UserDefaults.standard.bool(forKey: R.string.keys.isUserSignIn()) {
    //            configureWindowAndMakeVisible(rootVC: SalonMainTabBarController())
    //        } else {
    //
    //            let navVC = UINavigationController(rootViewController: R.storyboard.main.loginVC()!)
    //            configureWindowAndMakeVisible(rootVC: navVC)
    //        }
    //    }
    
    func configureWindowAndMakeVisible(rootVC: UIViewController) {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
        }
    }
}
