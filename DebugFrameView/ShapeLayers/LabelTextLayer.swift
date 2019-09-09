//
//  LabelTextLayer.swift
//  DebugFrameView
//
//  Created by Доценко Дмитрий on 03/09/2019.
//  Copyright © 2018 Sberbank. All rights reserved.
//

import UIKit

class LabelTextLayer: CATextLayer {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect) {
        super.init()
        
        getFramePath(frame: frame)
    }
    
    func getFramePath(frame: CGRect) {
        self.frame = frame
        fontSize = 10
        font = UIFont(name: "HelveticaNeue", size: 10)
        string = "\(frame.size.width)" + "x" + "\(frame.size.height)"
        alignmentMode = .center
        foregroundColor = UIColor.black.cgColor
        position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    override func draw(in ctx: CGContext) {
        let yOffset = bounds.midY - ((string as? NSAttributedString)?.size().height ?? fontSize) / 2
        ctx.saveGState()
        ctx.translateBy(x: 0, y: yOffset)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    
}
