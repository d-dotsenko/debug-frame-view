//
//  DebugFrameViewExtention.swift
//  DebugFrameView
//
//  Created by Action on 21/09/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func getSwitchItem(selector: Selector, isOn: Bool) -> UIBarButtonItem {
        let switchControl = UISwitch(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 50, height: 30)))
        switchControl.isOn = isOn
        switchControl.addTarget(self, action: selector, for: .valueChanged)
        return UIBarButtonItem.init(customView: switchControl)
    }
    
}
