//
//  DebugFrameDecorationCenter.swift
//  DebugFrameView
//
//  Created by Доценко Дмитрий on 03/09/2019.
//  Copyright © 2018 Sberbank. All rights reserved.
//

import UIKit

class DebugFrameDecorationCenter: DebugFrameDecoration {
    
    override class func addDecoration(views: [UIView]) {
        views.forEach { (aView) in
            
            if let _ = aView as? UIVisualEffectView {
                return
            }
            
            if aView.layer.sublayers?.filter({ (aLayer) in
                if let _ = aLayer as? CenterShapeLayer {
                    return true
                }
                return false
            }).count ?? 0 > 0 {
                return
            }
            
            let frameLayer = CenterShapeLayer(frame: aView.bounds)
            aView.layer.addSublayer(frameLayer)
        }
    }
    
    override class func removeDecoration(views: [UIView]) {
        views.forEach { (aView) in
            aView.layer.sublayers?.forEach({ (aLayer) in
                if let l = aLayer as? CenterShapeLayer {
                    l.removeFromSuperlayer()
                }
            })
        }
    }
    
}
