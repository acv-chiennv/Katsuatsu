//
//  AddUserViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/9/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FBSDKCoreKit
import FBSDKLoginKit

class AddUserViewController: BaseViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lbTitleHeader: UILabel!
    @IBOutlet weak var lbBirthday: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldWeight: UITextField!
    @IBOutlet weak var txtFieldHeight: UITextField!
    
    @IBOutlet weak var btnDone: UIButton!
    
    var user = User()
    var isEdit = false
    var dateSelected: Date?
    var genderSelected = 0
    var imageAvatar: Data?
    var actionSheet: ActionSheetDatePicker?
    var error: ERROR_INPUT?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateSelected = Date().getYearFromNow(year: -1)
        lbGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseGender)))
        lbGender.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAvatar)))
        avatar.isUserInteractionEnabled = true
        setupUI()
    }
    
    @IBAction func invokedGetUserFromFacebook(_ sender: Any) {
        
        if (FBSDKAccessToken.current() != nil) {
            print(FBSDKAccessToken.current().userID)
            getUserFacebookInfo()
        } else {
            let fbLogin = FBSDKLoginManager()
            fbLogin.logIn(withReadPermissions: ["email", "public_profile"], from: self, handler: { (fbResult, fbError) in
                print(fbResult.debugDescription)
                if fbError != nil {
                    print("Failed to login \(fbError!.localizedDescription)")
                    return
                }
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                print(accessToken)
                self.getUserFacebookInfo()
            })
        }
    }
    
    @IBAction func invokedButtonCalendar(_ sender: Any) {
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate:dateSelected , minimumDate: nil, maximumDate: Date().getYearFromNow(year: -1), doneBlock: { (picker, value, index) in
            let date = value as? Date
            self.dateSelected = date
            let dateString = UIUtils.getStringFromDate(date!, formatDate: "yyyy/MM/dd")
            self.lbBirthday.text = dateString
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
    
    @IBAction func invokedButtonDone(_ sender: Any) {
        
        if !checkInvalidInputIsOK() {
            return
        }
        let userNew = User()
        userNew.avatar = imageAvatar
        userNew.nickname = txtFieldName.text!
        userNew.gender = genderSelected
        userNew.age = UIUtils.caculatorAgeFromBirthDay(lbBirthday.text!)
        userNew.birthday = UIUtils.getDateFromString((lbBirthday.text)!, formatDate: "yyyy/MM/dd")
        userNew.height = Int(txtFieldHeight.text!)!
        userNew.weight = Int(txtFieldWeight.text!)!

        if isEdit {
            // Update user already exists
            userNew.id = user.id
            DataStore.sharedInstance.editUser(userNew)
            navigationController?.popToRootViewController(animated: true)
        } else {
            // Add new user => auto incrementID
            userNew.id = DataStore.sharedInstance.incrementUserID()
            // Add new user
            DataStore.sharedInstance.addUser(userNew)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddUserViewController {
    
    @objc func chooseAvatar(_ gesture: UITapGestureRecognizer) {
        let vc = CameraViewController(nibName: "CameraViewController", bundle: nil)
        vc.imageTaken = { image in
            self.avatar.image = image
            self.imageAvatar = image.data()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleChooseGender(_ gesture: UITapGestureRecognizer) {
        ActionSheetStringPicker.show(withTitle: "", rows: [GENDER_MALE, GENDER_FAMALE], initialSelection: genderSelected, doneBlock: { (picker, index, value) in
            let stringGender = value as? String
            self.lbGender.text = stringGender
            if stringGender == GENDER_MALE {
                self.genderSelected = 0
            } else if stringGender == GENDER_FAMALE {
                self.genderSelected = 1
            }
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
    
    func setupUI() -> Void {
        txtFieldName.limitCount(limit: 30)
        txtFieldWeight.limitCount(limit: 3)
        txtFieldHeight.limitCount(limit: 3)
        avatar.layer.cornerRadius = avatar.bounds.size.width / 2.0
        avatar.clipsToBounds = true
        
        if isEdit {
            lbTitleHeader.text = "プロフィール編集"
            if user.avatar != nil {
                avatar.image = UIImage(data: (user.avatar)!)
                imageAvatar = user.avatar
            }
            txtFieldName.text = user.nickname
            lbBirthday.text = UIUtils.getStringFromDate(user.birthday, formatDate: "yyyy/MM/dd")
            if user.gender == 0 {
                lbGender.text = GENDER_MALE
                genderSelected = 0
            } else if user.gender == 1 {
                lbGender.text = GENDER_FAMALE
                genderSelected = 1
            }
            txtFieldWeight.setTextDefault(text: String(user.weight))
            txtFieldHeight.setTextDefault(text: String(user.height))
            btnDone.setTitle("保存", for: .normal)
            
            dateSelected = user.birthday
        } else {
            btnDone.setTitle("追加", for: .normal)
            lbTitleHeader.text = "ユーザー追加"
            txtFieldWeight.setTextDefault(text: "0")
            txtFieldHeight.setTextDefault(text: "0")
        }
    }
    
    func getUserFacebookInfo() {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name ,email , picture.type(large)"])
        graphRequest.start { (connection, result, error) in
            if error != nil {
                print("Get Info Error")
            } else {
                print(result.debugDescription)
                guard let data = result as? [String: Any] else {
                    return
                }
                
                self.parseDataUserFacebook(data)
            }
        }
    }
    
    func parseDataUserFacebook(_ dic: [String: Any]) {
        txtFieldName.text = dic["name"] as? String
        if let pictureDic = dic["picture"] as? [String: Any] {
            if let data = pictureDic["data"] as? [String: Any] {
                if let url = data["url"] as? String {
                    avatar.image =  UIUtils.base64ToUIImage(UIUtils.getBase64StringFromImageURL(url)!)
                    imageAvatar = UIUtils.base64ToUIImage(UIUtils.getBase64StringFromImageURL(url)!)?.data()
                }
            }
        }
    }
}

extension AddUserViewController {
    func checkInvalidInputIsOK() -> Bool {

        if (txtFieldName.text?.isEmpty)! {
            error = ERROR_INPUT(rawValue:ERROR_INPUT.INPUT_NAME.rawValue)
            let message = error?.isShowErrorMessage(error!)
            CustomAlertViewController.create()
                .setHeightAlert(height: HEIGHT_ALERT_ERROR)
                .setMessage(message: message)
                .show()
            return false
        }
        if (lbBirthday.text?.isEmpty)! {
            error = ERROR_INPUT(rawValue:ERROR_INPUT.INPUT_BIRTHDAY.rawValue)
            let message = error?.isShowErrorMessage(error!)
            CustomAlertViewController.create()
                .setHeightAlert(height: HEIGHT_ALERT_ERROR)
                .setMessage(message: message)
                .show()
            return false
        }
        if (lbGender.text?.isEmpty)! {
            error = ERROR_INPUT(rawValue:ERROR_INPUT.INPUT_GENDER.rawValue)
            let message = error?.isShowErrorMessage(error!)
            CustomAlertViewController.create()
                .setHeightAlert(height: HEIGHT_ALERT_ERROR)
                .setMessage(message: message)
                .show()
            return false
        }
        if txtFieldWeight.text == "" || txtFieldWeight.text == "0"{
            error = ERROR_INPUT(rawValue:ERROR_INPUT.INPUT_WEIGHT.rawValue)
            let message = error?.isShowErrorMessage(error!)
            CustomAlertViewController.create()
                .setHeightAlert(height: HEIGHT_ALERT_ERROR)
                .setMessage(message: message)
                .show()
            return false
        }
        if txtFieldHeight.text == "" || txtFieldHeight.text == "0" {
            error = ERROR_INPUT(rawValue:ERROR_INPUT.INPUT_HEIGHT.rawValue)
            let message = error?.isShowErrorMessage(error!)
            CustomAlertViewController.create()
                .setHeightAlert(height: HEIGHT_ALERT_ERROR)
                .setMessage(message: message)
                .show()
            return false
        }
        return true
    }
}
