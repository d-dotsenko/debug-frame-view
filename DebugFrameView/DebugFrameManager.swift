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
            UIView.doSwizzle(isOn: isDebug)
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
    
    var isCenterLayer: Bool = false {
        didSet {
            _setup()
        }
    }
    
    var isLabelLayer: Bool = false {
        didSet {
            _setup()
        }
    }
    
    public func update() {
        let parentView = UIApplication.shared.keyWindow
        guard let allViews = parentView?.getAllViews() else {
            return
        }
        updateForViews(views: allViews)
    }
    
    public func updateForViews(views: [UIView]) {
        if isDebug {
            DebugFrameDecorationShape.setup(views: views, isOn: isFrameLayer)
            DebugFrameDecorationColor.setup(views: views, isOn: isColorLayer)
            DebugFrameDecorationCenter.setup(views: views, isOn: isCenterLayer)
            DebugFrameDecorationLabel.setup(views: views, isOn: isLabelLayer)
        } else {
            DebugFrameDecorationShape.setup(views: views, isOn: false)
            DebugFrameDecorationColor.setup(views: views, isOn: false)
            DebugFrameDecorationCenter.setup(views: views, isOn: false)
            DebugFrameDecorationLabel.setup(views: views, isOn: false)
        }
    }
    
    /// MARK: - Private
    
    private func _setup() {
        update()
//        UIView.doSwizzle(isOn: isDebug)
    }
    
}

extension UIView {
    
    func getAllViews() -> [UIView] {
        var allViews = [UIView]()
        for aView in subviews {
            allViews += aView.getAllViews()
            allViews.append(aView)
        }
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
        
        DebugFrameManager.shared.updateForViews(views: [self])
    }
    
    @objc func border_removeFromSuperview() {
        self.border_removeFromSuperview()
        
        let views = getAllViews()
        
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
    
    func getDepthOfView(view: UIView, pDepth: Int) -> Int {
        
        let subviews = view.subviews
        if subviews.count == 0 {
            return pDepth
        }
        
        for v in subviews {
            return getDepthOfView(view: v, pDepth: pDepth + 1)
        }
        
        return pDepth
    }
}

