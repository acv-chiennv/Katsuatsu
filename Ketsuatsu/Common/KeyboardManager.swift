//
//  KeyboardManager.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/12/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import IQKeyboardManager

class KeyboardManager: NSObject {
    var view:UIView?
    
    func enableIQKeyboard(enable:Bool){
        IQKeyboardManager.shared().isEnabled = enable
        IQKeyboardManager.shared().isEnableAutoToolbar = enable
    }
    
    func onCreate(view:UIView?){
        self.view = view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func onDestroy(){
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view == nil {
                return
            }
            
            self.view?.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view == nil {
            return
        }
        self.view?.frame.origin.y = 0
    }
}
