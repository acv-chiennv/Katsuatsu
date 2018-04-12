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

//UITextInput : UITextView, UITextField
public protocol CallBackTextFieldDidChange {
    func textViewDidChange(textField: UITextField)
    func textViewDidChange(textView: UITextView)
}
var _Handle: UInt8 = 42
var _HandleCallBack: UInt8 = 43
var _HandleCallBackEnableCopyPaste: UInt8 = 44

extension UITextInput{
    var isEnableCopyPaste : Bool
    {
        get {
            if (objc_getAssociatedObject(self, &_HandleCallBackEnableCopyPaste) == nil) {
                self.isEnableCopyPaste = true
            }
            return objc_getAssociatedObject(self, &_HandleCallBackEnableCopyPaste) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &_HandleCallBackEnableCopyPaste, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    var mCallBackTextFieldDidChange: CallBackTextFieldDidChange?{
        get {
            return objc_getAssociatedObject(self, &_HandleCallBack) as? CallBackTextFieldDidChange
        }
        set {
            objc_setAssociatedObject(self, &_HandleCallBack, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        }
    }
    
    var mMaxLength : Int
    {
        get {
            if (objc_getAssociatedObject(self, &_Handle) == nil) {
                self.mMaxLength = 0
            }
            return objc_getAssociatedObject(self, &_Handle) as! Int
        }
        set {
            objc_setAssociatedObject(self, &_Handle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UITextField {
    
    // set text default
    func setTextDefault(text: String) {
        self.text = text
        self.addTarget(self, action: #selector(mTextFieldDidBeginEdit), for: UIControlEvents.editingDidBegin)
        self.addTarget(self, action: #selector(mTextFieldDidEndEdit), for: UIControlEvents.editingDidEnd)
    }
    
    @objc func mTextFieldDidBeginEdit(textField: UITextField) {
        if self.text == "0" {
            self.text = ""
        }
    }
    
    @objc func mTextFieldDidEndEdit(textField: UITextField) {
        self.text = UIUtils.removeFirstCharacterIsZero(self.text!)
        if self.text == "" {
            self.text = "0"
        }
    }
    
    // Disable paste in textfield if need
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) && !isEnableCopyPaste {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    // when maxlength character input
    func limitCount(limit : Int){
        mMaxLength = limit
        self.addTarget(self, action: #selector(mTextFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func mTextFieldDidChange(textField: UITextField) {
        if(mMaxLength > 0){
            if mMaxLength < (textField.text?.count)! {
                let textStr : String = (textField.text)!
                let index = textStr.index(textStr.startIndex, offsetBy: mMaxLength)
                let mText = String(textStr[..<index])
                
                textField.text = mText
            }
        }
        
        if mCallBackTextFieldDidChange != nil {
            mCallBackTextFieldDidChange?.textViewDidChange(textField: textField)
        }
    }
}

