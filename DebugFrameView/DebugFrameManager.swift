//
//  DebugFrameManager.swift
//  DebugFrameView
//
//  Created by Action on 31/08/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit

class DebugFrameManager {
    
    /// MARK: - Life Cicle
    
    static let shared = DebugFrameManager()
    
    private init() {
        
    }
    
    /// MARK: - Public VARs
    
    var isDebug: Bool = false {
        didSet {
            _setup()
        }
    }
    
    var isFrameLayer: Bool = true {
        didSet {
            _setup()
        }
    }
    
    var isColorLayer: Bool = true {
        didSet {
            _setup()
        }
    }
    
    public func update() {
        let parentView = UIApplication.shared.keyWindow
        guard let allViews = parentView?.getAllViews() else {
            return
        }
        if isDebug {
            _setupFrameLayers(views: allViews, isOn: isFrameLayer)
            _setupColorLayers(views: allViews, isOn: isColorLayer)
        } else {
            _setupFrameLayers(views: allViews, isOn: false)
            _setupColorLayers(views: allViews, isOn: false)
        }
    }
    
    /// MARK: - Private
    
    private func _setup() {
        update()
        UIView.doSwizzle(isOn: isDebug)
    }
    
    private func _setupFrameLayers(views: [UIView], isOn: Bool) {
        if isOn {
            _addFrameLayers(views: views)
        } else {
            _removeFrameLayers(views: views)
        }
    }
    
    private func _setupColorLayers(views: [UIView], isOn: Bool) {
        if isOn {
            _addColorLayers(views: views)
        } else {
            _removeColorLayers(views: views)
        }
    }
    
    
    
    private func _addFrameLayers(views: [UIView]) {
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
    
    private func _removeFrameLayers(views: [UIView]) {
        views.forEach { (aView) in
            aView.layer.sublayers?.forEach({ (aLayer) in
                if let l = aLayer as? FrameShapeLayer {
                    l.removeFromSuperlayer()
                }
            })
        }
    }
    
    private func _addColorLayers(views: [UIView]) {
        views.forEach { (aView) in
            
            if aView.layer.sublayers?.filter({ (aLayer) in
                if let _ = aLayer as? ColorShapeLayer {
                    return true
                }
                return false
            }).count ?? 0 > 0 {
                return
            }
            
            
            let color = UIColor(red: CGFloat.random(in: 0...1),
                                green: CGFloat.random(in: 0...1),
                                blue: CGFloat.random(in: 0...1),
                                alpha: 1)
            
            let colorLayer = ColorShapeLayer(frame: aView.bounds, color: color)
            aView.layer.insertSublayer(colorLayer, at: 0)
            print(aView.layer.sublayers)
        }
    }
    
    private func _removeColorLayers(views: [UIView]) {
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
        
        DebugFrameManager.shared.update()
    }
}

