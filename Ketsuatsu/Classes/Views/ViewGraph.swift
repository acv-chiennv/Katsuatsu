//
//  ViewGraph.swift
//  Ketsuatsu
//
//  Created by ChuoiChien on 4/25/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class ViewGraph: UIView {
    
    var sublayer = CALayer()
    var mLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        mLayer.frame = self.bounds
        mLayer.backgroundColor = UIColor.clear.cgColor
        
        let initialRect:CGRect = CGRect.init(x: 0, y: self.bounds.size.height, width: self.bounds.size.width, height: 0)
        sublayer.frame = initialRect
        sublayer.backgroundColor = UIColor.red.cgColor
        
        let mask:CAShapeLayer = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath
        
        mLayer.addSublayer(sublayer)
        mLayer.mask = mask
        
        self.layer.addSublayer(mLayer)
    }
    
    func drawGraph(_ sisValue: Int, _ diaValue: Int, isEnd: Bool ) {
        
        let sisCGFloat = CGFloat((sisValue) * Int(self.bounds.size.height) / 250)
        let diaCGFloat = CGFloat((diaValue) * Int(self.bounds.size.height) / 250)
        
        let finalRect:CGRect = CGRect.init(x: 0, y: self.bounds.size.height, width: self.bounds.size.width, height: sisCGFloat * 2)
        let boundsAnim = CABasicAnimation(keyPath: "bounds")
        boundsAnim.toValue = finalRect
        
        let anim = CAAnimationGroup()
        anim.animations = [boundsAnim]
        anim.isRemovedOnCompletion = false
        anim.duration = 0.1
        anim.fillMode = kCAFillModeForwards
        sublayer.add(anim, forKey: nil)
        
        if isEnd {
            let layerEnd = CALayer()
            layerEnd.frame = CGRect(x: 0, y: self.bounds.size.height - sisCGFloat, width: self.bounds.size.width, height: CGFloat(sisCGFloat - diaCGFloat))
            layerEnd.backgroundColor = UIColor.red.cgColor
            sublayer.backgroundColor = UIColor.clear.cgColor
            mLayer.addSublayer(layerEnd)
        }
    }
}
