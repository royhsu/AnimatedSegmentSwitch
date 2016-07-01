//
//  ViewController.swift
//  AnimatedSegmentSwitch
//
//  Created by Tobias Schmid on 09/18/2015.
//  Copyright (c) 2015 Tobias Schmid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentControl: AnimatedSegmentSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarStyle = .LightContent

        navigationController!.navigationBar.translucent = false
        navigationController!.navigationBar.barTintColor = .customLightYellowColor()
        
        if let control = segmentControl {
            
            control.thumbCornerRadius = 1.0
            control.thumbInset = 0.0

            control.thumbColor = .customGreenColor()
            control.normalColor = .customRedColor()
            control.selectedColor = .whiteColor()

            control.items = [
                UIImage(named: "item1")!.imageWithRenderingMode(.AlwaysTemplate),
                UIImage(named: "item2")!.imageWithRenderingMode(.AlwaysTemplate)
            ]
        }
    }

    func segmentValueDidChange(sender: AnimatedSegmentSwitch) {
        print("valueChanged: \(sender.selectedIndex)")
    }

    @IBAction func segmentValueChanged(sender: AnimatedSegmentSwitch!) {

        sender.selectedColor = .whiteColor()

        if sender.selectedIndex == 0 {
            sender.thumbColor = .customGreenColor()
            sender.normalColor = .customRedColor()
        } else if sender.selectedIndex == 1 {
            sender.thumbColor = .customRedColor()
            sender.normalColor = .customGreenColor()
        }
    }
}

extension UIColor {

    class func customYellowColor() -> UIColor {
        return UIColor(red: 229.0/255.0, green: 163.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }

    class func customLightYellowColor() -> UIColor {
        return UIColor(red: 252.0/255.0, green: 182.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    }

    class func customRedColor() -> UIColor {
        return UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    }

    class func customGreenColor() -> UIColor {
        return UIColor(red: 85.0/255.0, green: 238.0/255.0, blue: 151.0/255.0, alpha: 1)
    }

    class func customBlueColor() -> UIColor {
        return UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1)
    }

    class func lyftPinkColor() -> UIColor {
        return UIColor(red: 234.0/255.0, green: 11.0/255.0, blue: 140.0/255.0, alpha: 1.0)
    }

    class func lyftGrayColor() -> UIColor {
        return UIColor(red: 51.0/255.0, green: 61.0/255.0, blue: 71.0/255.0, alpha: 1.0)
    }

    class func lyftLightGrayColor() -> UIColor {
        return UIColor(red: 77.0/255.0, green: 94.0/255.0, blue: 107.0/255.0, alpha: 1.0)
    }
}