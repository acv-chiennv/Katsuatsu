//
//  CustomAlertViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnOK1: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var alertBgView: UIView!
    @IBOutlet weak var heightAlertContraint: NSLayoutConstraint!
    
    var heightAlert: CGFloat?
    var alertMessage: Any?
    var titleOk : String?
    var titleCancel : String?
    var isOneButton : Bool = true
  
    var btnOKClicked: (() -> Void)?
    var btnCancelClicked: (() -> Void)?
    
    static func create() -> CustomAlertViewController{
        let alert = UIUtils.viewControllerWithIndentifier(identifier: "CustomAlertViewController", storyboardName: "Main") as? CustomAlertViewController
        return alert!
    }
    
    func setHeightAlert(height:CGFloat?) -> CustomAlertViewController{
        self.heightAlert = height
        return self
    }
    
    func setbtnOKClicked(btnOKClicked:(() -> Void)?) -> CustomAlertViewController{
        self.btnOKClicked = btnOKClicked
        return self
    }
    
    func setbtnCancelClicked(btnCancelClicked:(() -> Void)?) -> CustomAlertViewController{
        self.btnCancelClicked = btnCancelClicked
        return self
    }

    func setTitleOk(title:String?) -> CustomAlertViewController{
        titleOk = title
        return self
    }
    
    func setIsOneButton(isOne:Bool) -> CustomAlertViewController{
        isOneButton = isOne
        return self
    }

    func setTitleCancel(title:String?) -> CustomAlertViewController{
        titleCancel = title
        return self
    }
    
    func setMessage(message:Any?) -> CustomAlertViewController{
        alertMessage = message
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        if heightAlert != nil {
            self.heightAlertContraint.constant = heightAlert!
        }
        alertBgView.cornerRadius(radius: 10.0, color: UIColor.white, borderWidth: nil)
        
        let visualEffectView = UIVisualEffectView(frame: self.view.bounds)
        visualEffectView.effect = UIBlurEffect(style: .dark)
        visualEffectView.alpha = 0.6
        self.view.addSubview(visualEffectView)
        self.view.sendSubview(toBack: visualEffectView)
        
        if alertMessage is NSAttributedString {
             lblMessage.attributedText = alertMessage as! NSAttributedString?
        }else if alertMessage is String {
            lblMessage.text = alertMessage as? String
        }
        UIUtils.fontLineSpacing(lblMessage, lineSpacing: 8)
        btnOk.isHidden = !isOneButton
        btnOK1.isHidden = isOneButton
        btnCancel1.isHidden = isOneButton
        
        if titleOk != nil {
            btnOk.setTitle(titleOk, for: UIControlState.normal)
            btnOK1.setTitle(titleOk, for: UIControlState.normal)
        }
        
        if titleCancel != nil {
            btnCancel1.setTitle(titleCancel, for: UIControlState.normal)
        }
    }
    
    @IBAction func btnOK_actionTouchUpInside(_ sender: Any) {
        dismiss(animated: false, completion: {
            if let block = self.btnOKClicked {
                block()
            }
        })
    }
    
    @IBAction func btnCancel_actionTouchUpInside(_ sender: Any) {
        dismiss(animated: false, completion: {

            if let block = self.btnCancelClicked {
                block()
            }
        })
    }
    
    func show() -> Void {
        AppDelegate.shareInstance.window?.rootViewController?.present(self, animated: false, completion: nil)
    }
}


