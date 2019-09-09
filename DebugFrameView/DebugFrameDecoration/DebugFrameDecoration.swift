//
//  DebugFrameDecoration.swift
//  DebugFrameView
//
//  Created by Доценко Дмитрий on 03/09/2019.
//  Copyright © 2018 Sberbank. All rights reserved.
//

import UIKit

class DebugFrameDecoration: NSObject {
    
    class func setup(views: [UIView], isOn: Bool) {
        if isOn {
            addDecoration(views: views)
        } else {
            removeDecoration(views: views)
        }
    }
    
    class func addDecoration(views: [UIView]) {
    }
    
    class func removeDecoration(views: [UIView]) {
    }
    
}
