//
//  DebugFrameManager.swift
//  DebugFrameView
//
//  Created by Action on 31/08/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit

class DebugFrameManager {
    
    static let shared = DebugFrameManager()
    
    private init() {
        
    }
    
    var isDebug: Bool = false {
        didSet {
            setup()
        }
    }
    
    var isFrameLayer: Bool = true {
        didSet {
            setup()
        }
    }
    
    var isColorLayer: Bool = true {
        didSet {
            setup()
        }
    }
    
    func setup() {
        let parentView = UIApplication.shared.keyWindow
        guard let allViews = parentView?.getAllViews() else {
            return
        }
        if isDebug {
            _setupColorLayers(views: allViews, isOn: isColorLayer)
            _setupFrameLayers(views: allViews, isOn: isFrameLayer)
        } else {
            _setupColorLayers(views: allViews, isOn: false)
            _setupFrameLayers(views: allViews, isOn: false)
        }
        
        UIView.doSwizzle(isOn: isDebug)
    }
    
    func _setupFrameLayers(views: [UIView], isOn: Bool) {
        if isOn {
            _addFrameLayers(views: views)
        } else {
            _removeFrameLayers(views: views)
        }
    }
    
    func _setupColorLayers(views: [UIView], isOn: Bool) {
        if isOn {
            _addColorLayers(views: views)
        } else {
            _removeColorLayers(views: views)
        }
    }
    
    func _addFrameLayers(views: [UIView]) {
        views.forEach { (aView) in
            if aView.layer.sublayers?.filter({ (aLayer) in
                if let _ = aLayer as? FrameShapeLayer {
                    return true
                }
                return false
            }).count ?? 0 > 0 {
                return
            }
            
            let frameLayer = FrameShapeLayer(frame: aView.bounds)
            aView.layer.addSublayer(frameLayer)
        }
    }
    
    func _removeFrameLayers(views: [UIView]) {
        views.forEach { (aView) in
            aView.layer.sublayers?.forEach({ (aLayer) in
                if let l = aLayer as? FrameShapeLayer {
                    l.removeFromSuperlayer()
                }
            })
        }
    }
    
    func _addColorLayers(views: [UIView]) {
        views.forEach { (aView) in
            if aView.layer.sublayers?.filter({ (aLayer) in
                if let _ = aLayer as? ColorShapeLayer {
                    return true
                }
                return false
            }).count ?? 0 > 0 {
                return
            }
            let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
            let frameLayer = ColorShapeLayer(frame: aView.bounds, color: randomColor)
            aView.layer.insertSublayer(frameLayer, at: 0)
        }
    }
    
    func _removeColorLayers(views: [UIView]) {
        let views = views.reversed()
        views.forEach { (aView) in
            aView.layer.sublayers?.forEach({ (aLayer) in
                if let l = aLayer as? ColorShapeLayer {
                    l.removeFromSuperlayer()
                }
            })
        }
    }
}

extension UIView {
    func getAllViews() -> [UIView] {
        var allViews = [UIView]()
        let closure: (UIView) -> Void = { aView in
            allViews.append(aView)
            for sub in aView.subviews {
                allViews += sub.getAllViews()
            }
        }
        closure(self)
        return allViews
    }
}

private let swizzling:(UIView.Type, Bool) -> () = { aView, isOn in

    let originalSelector = isOn ? #selector(aView.layoutSubviews) : #selector(aView.border_layoutSubviews)
    let swizzledSelector = isOn ? #selector(aView.border_layoutSubviews) : #selector(aView.layoutSubviews)
    
    let originalMethod = class_getInstanceMethod(aView, originalSelector)
    let swizzledMethod = class_getInstanceMethod(aView, swizzledSelector)
    
    guard let aOriginalMethod = originalMethod, let aSwizzledMethod = swizzledMethod else {
        return
    }
    
    method_exchangeImplementations(aOriginalMethod, aSwizzledMethod)
}

extension UIView {
    
    final public class func doSwizzle(isOn: Bool) {
        swizzling(self, isOn)
    }
    
    @objc func border_layoutSubviews() {
        self.border_layoutSubviews()
        
        if layer.sublayers?.filter({ (aLayer) in
            if let _ = aLayer as? FrameShapeLayer {
                return true
            }
            return false
        }).count ?? 0 > 0 {
            return
        }
        
        let frameLayer = FrameShapeLayer(frame: bounds)
        layer.addSublayer(frameLayer)
    }
}

