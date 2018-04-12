//
//  UIExtension.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

extension UIView {
    func cornerRadius(radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func cornerRadius(radius : CGFloat, color:UIColor?, borderWidth:CGFloat?) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        if color != nil {
            self.layer.borderColor = color!.cgColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
    }
    
    func setFontSize(size:CGFloat, bold:Bool){
        let font = UIFont(descriptor: UIFontDescriptor(name: (bold ? FONT_DESCRIPTION_NAME.FONT_DESCRIPTION_YU_GOTHIC_BOLD : FONT_DESCRIPTION_NAME.FONT_DESCRIPTION_YU_GOTHIC_MEDIUM ) , size: size), size: size)
        if self is UILabel {
            (self as! UILabel).font = font
        } else if self is UIButton {
            //(self as! UIButton).font = font
        }else if self is UITextField {
            (self as! UITextField).font = font
        }else if self is UITextView{
            (self as! UITextView).font = font
        }
    }
}

