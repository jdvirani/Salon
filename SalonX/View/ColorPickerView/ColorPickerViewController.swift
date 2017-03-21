//
//  ColorPickerViewController.swift
//  SalonX
//
//  Created by DK on 22/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import Color_Picker_for_iOS

class ColorPickerViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    var colorPickerView = HRColorPickerView()
    
    convenience init() {
        self.init(nibName: R.nib.colorPickerView.name, bundle: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.30)
            self.view.transform = .identity
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(colorPicked), name: NSNotification.Name(rawValue: "colorPicked"), object: nil)
        
        setupColorPickerView()
        
        print("enter in did load")
        // Do any additional setup after loading the view.
    }
    
    func colorPicked() {
        if let color = colorPickerView.color {
            print(color)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "colorChanged"), object: ["color" : color])
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func setupColorPickerView() {
        
        colorPickerView.color = UIColor(colorLiteralRed: 50.0/255.0, green: 53.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        
        var colorMapView = HRColorMapView()
        
        colorMapView.color = UIColor(colorLiteralRed: 50.0/255.0, green: 53.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        colorMapView.saturationUpperLimit = 1
        colorMapView.tileSize = 1
        colorMapView.frame = CGRect(x: 0, y: 0, width: colorView.frame.width, height: colorView.frame.height)
        colorPickerView.addSubview(colorMapView)
        
        colorPickerView.colorMapView = colorMapView
        colorPickerView.colorInfoView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        colorPickerView.brightnessSlider.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        
        colorPickerView.frame = CGRect(x: 0, y: 0, width: colorView.frame.width, height: colorView.frame.height)
        
       // colorPickerView.addTarget(self, action: #selector(colorChanged), for: .touchDragInside)
        colorView.addSubview(colorPickerView)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        colorPickerView.frame = CGRect(x: 0, y: 0, width: colorView.frame.width, height: colorView.frame.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.clear
        }
    }
    
    func colorChanged() {
        
        //        if let color = colorPickerView.color {
        //            print(color)
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "colorChanged"), object: ["color" : color])
        //            dismiss(animated: true, completion: nil)
        //
        //        }
        
    }
    
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        print(touches)
    //        if let color = colorPickerView.color {
    //            print(color)
    //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "colorChanged"), object: ["color" : color])
    //            dismiss(animated: true, completion: nil)
    //
    //        }
    //    }
    
    //    @IBAction func btnDoneTapped(_ sender: UIButton) {
    //        if let color = colorPickerView.color {
    //            print(color)
    //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "colorChanged"), object: ["color" : color])
    //            dismiss(animated: true, completion: nil)
    //            
    //        }
    //    }
    
}
















