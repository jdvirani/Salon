//
//  AddGroupPopupViewController.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class AddGroupPopupViewController: UIViewController {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtGroupName: UITextField!
    var newGroupAddedDelegate: NewGroupAddedDelegate!
    
    var isEditMode = false
    
    convenience init() {
        self.init(nibName: R.nib.addGroupPopupView.name, bundle: nil)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.30)
            self.view.transform = .identity
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editGroupName(_:)), name: NSNotification.Name("editGroupName"), object: nil)
        
        btnAdd.layer.cornerRadius = btnAdd.frame.height / 2
        btnAdd.clipsToBounds = true
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnfromKeyboardClicked))
        viewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        txtGroupName.inputAccessoryView = viewForDoneButtonOnKeyboard
        
    }
    
    func editGroupName(_ userInfo: Notification) {
        print(userInfo)
        if let myDict = userInfo.object as? [String : String] {
            if let name = myDict["name"] {
                txtGroupName.text = name
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func btnAddTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
        
        if !(txtGroupName.text?.isEmpty)! {
            newGroupAddedDelegate.didNewGroupAdded(groupName: txtGroupName.text!)
            
        } else {
            let alert = UIAlertController(title: "SalonX", message: "Please Enter valid name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneBtnfromKeyboardClicked (sender: Any) {
        print("Done Button Clicked.")
        //Hide Keyboard by endEditing or Anything you want.
        self.view.endEditing(true)
    }
}
