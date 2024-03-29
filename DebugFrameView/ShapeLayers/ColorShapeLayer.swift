//
//  ColorShapeLayer.swift
//  DebugFrameView
//
//  Created by Action on 01/09/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit


class ColorShapeLayer: CAGradientLayer {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init()
        
        self.frame = frame
        self.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.type = .radial
        let center = CGPoint(x: 0.5, y: 0.5)
        self.startPoint = center
        
        let radius = 3
        self.endPoint = CGPoint(x: radius, y: radius)
    }
    
    func getFramePath(frame: CGRect, color:UIColor) {
        
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
//        path = aPath.cgPath
        
//        strokeColor = color.cgColor
//        lineWidth = defaultLineWidth
        
//        fillColor = color.cgColor
        
    }
}
