//
//  PersonalViewController.swift
//  SalonX
//
//  Created by DK on 22/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
    @IBOutlet weak var lblHeaderInfo: UILabel!
    @IBOutlet var btnCornerStyle: [UIButton]!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var viewColor: UIView!
    
    @IBOutlet weak var lblDuration: UILabel!
    
    
    var durationTag = 3 {
        didSet {
            if durationTag == 1 {
                lblDuration.text = "15 min"
            } else if durationTag == 2 {
                lblDuration.text = "30 min"
            } else if durationTag == 3 {
                lblDuration.text = "45 min"
            }
        }
    }

    convenience init() {
        self.init(nibName: R.nib.personalVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(colorChanged), name: NSNotification.Name(rawValue: "colorChanged"), object: nil)
        
        setupBackButton()
        
        durationTag = 3
        
        setupUI()
    

    }
    
    func colorChanged(notification: NSNotification) {
        let dict = notification.object as! NSDictionary
        let color = dict["color"] as! UIColor
        viewColor.backgroundColor = color
    }
    
    func setupUI() {
        btnCornerStyle.forEach({ $0.layer.cornerRadius = $0.frame.height / 2
            $0.clipsToBounds = true })
        
        txtNote.addCornerAndBorderStyle()
        
        
        let artistName = NSAttributedString(string: "Bebe Veja", attributes: [ NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!, NSForegroundColorAttributeName: R.color.salonX.accent()])
        
        let precedingString = NSAttributedString(string: "Start at 17:00-17:45 Marti 27 Sept 2016 By ", attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!, NSForegroundColorAttributeName: R.color.salonX.headerBG()])
        
        let finalHeaderString = NSMutableAttributedString()
        finalHeaderString.append(precedingString)
        finalHeaderString.append(artistName)
        
        lblHeaderInfo.attributedText = finalHeaderString
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        
        let vc = ColorPickerViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func btnIncrementTapped(_ sender: UIButton) {
        if durationTag < 4 {
            durationTag += 1
        }
    }
    
    @IBAction func btnDecrementTapped(_ sender: UIButton) {
        if durationTag > 0 {
            durationTag -= 1
        }
    }
    
    

}
