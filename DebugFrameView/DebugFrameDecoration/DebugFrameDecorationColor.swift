//
//  DebugFrameDecorationColor.swift
//  DebugFrameView
//
//  Created by Доценко Дмитрий on 03/09/2019.
//  Copyright © 2018 Sberbank. All rights reserved.
//

import UIKit

class DebugFrameDecorationColor: DebugFrameDecoration {
    
    override class func addDecoration(views: [UIView]) {
        
        let views = views.sorted { (v1, v2) -> Bool in
            let depth1 = v1.getDepthOfView(view: v1, pDepth: 0)
            let depth2 = v2.getDepthOfView(view: v2, pDepth: 0)
            return depth1 > depth2
        }
        
        views.forEach { (aView) in

            if let _ = aView as? UIVisualEffectView {
                return
            }
//
//            if let _ = aView as? UILabel {
//                return
//            }
            
//            CASpringAnimation
            
//            swiftClassFromString
            
            let layers = aView.layer.sublayers?.filter({ (aLayer) in
                if let _ = aLayer as? ColorShapeLayer {
                    return true
                }
                return false
            })
            
            if layers?.count ?? 0 > 0 {
                for aLayer in layers ?? [] {
                    aView.layer.insertSublayer(aLayer, at: 0)
                }
                return
            }
            
//            if let aClass = NSObject.swiftClassFromString(className: "_UIParallaxDimmingView") as? AnyClass.Type {
//                //let temp = aView as? aClass
//                if aView.isKind(of: aClass) == true {
//                    return
//                }
//
//            }
            
            
            let color = UIColor(red: CGFloat.random(in: 0...1),
                                green: CGFloat.random(in: 0...1),
                                blue: CGFloat.random(in: 0...1),
                                alpha: 1)
            
            let colorLayer = ColorShapeLayer(frame: aView.bounds, color: color)
            aView.layer.insertSublayer(colorLayer, at: 0)
        }
    }
    
    override class func removeDecoration(views: [UIView]) {
        views.forEach { (aView) in
            aView.layer.sublayers?.forEach({ (aLayer) in
                if let l = aLayer as? ColorShapeLayer {
                    l.removeFromSuperlayer()
                }
            })
        }
    }
    
}
