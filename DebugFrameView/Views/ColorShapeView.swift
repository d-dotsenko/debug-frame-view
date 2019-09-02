//
//  ColorShapeView.swift
//  DebugFrameView
//
//  Created by Action on 01/09/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit

class ColorShapeView: UIView {
    
    let color: UIColor
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect, color: UIColor) {
        self.color = color
        
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = color
    }
}
