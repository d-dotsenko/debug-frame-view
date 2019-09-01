//
//  FrameShapeLayer.swift
//  DebugFrameView
//
//  Created by Action on 31/08/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit

class FrameShapeLayer: CAShapeLayer {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect) {
        super.init()
        
        getFramePath(frame: frame)
    }
    
    func getFramePath(frame: CGRect) {
        
        let defaultColor = UIColor(red: 243.0/255.0, green: 231.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        let defaultLineWidth: CGFloat = 1
        let aPath = UIBezierPath()
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: frame.size.width, y: 0),
            CGPoint(x: frame.size.width, y: frame.size.height),
            CGPoint(x: 0, y: frame.size.height)
        ]
        for (index, point) in points.enumerated().lazy {
            switch index {
            case 0:
                aPath.move(to: point)
                
            case points.count-1:
                aPath.addLine(to: point)
                aPath.close()
                
            default:
                aPath.addLine(to: point)
            }
        }
        path = aPath.cgPath
        strokeColor = defaultColor.cgColor
        lineWidth = defaultLineWidth
        fillColor = UIColor.clear.cgColor
    }
}
