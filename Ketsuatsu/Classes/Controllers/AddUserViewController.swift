//
//  AddUserViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/9/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

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
    var actionSheet: ActionSheetDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet?.maximumDate = Date()
        lbGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseGender)))
        lbGender.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAvatar)))
        avatar.isUserInteractionEnabled = true
        setupUI()
    }
    
    @IBAction func invokedButtonCalendar(_ sender: Any) {
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate:dateSelected , minimumDate: nil, maximumDate: NSDate() as Date?, doneBlock: { (picker, value, index) in
            let date = value as? Date
            let dateString = UIUtils.getStringFromDate(date!, formatDate: "yyyy/MM/dd")
            self.lbBirthday.text = dateString
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
}

extension AddUserViewController {
    
    @objc func chooseAvatar(_ gesture: UITapGestureRecognizer) {
        let vc = CameraViewController(nibName: "CameraViewController", bundle: nil)
        vc.imageTaken = { image in
            self.avatar.image = image
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleChooseGender(_ gesture: UITapGestureRecognizer) {
        ActionSheetStringPicker.show(withTitle: "", rows: [GENDER_MALE, GENDER_FAMALE], initialSelection: genderSelected, doneBlock: { (picker, index, value) in
            let stringGender = value as? String
            self.lbGender.text = stringGender
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
            txtFieldName.text = user.nickname
            lbBirthday.text = user.birthday
            lbGender.text = user.gender
            txtFieldWeight.setTextDefault(text: user.weight!)
            txtFieldHeight.setTextDefault(text: user.height!)
            btnDone.setTitle("保存", for: .normal)
            
            dateSelected = UIUtils.getDateFromString(user.birthday!, formatDate: "yyyy/MM/dd")
            if user.gender == GENDER_MALE {
                genderSelected = 0
            } else if user.gender == GENDER_FAMALE {
                genderSelected = 1
            }
        } else {
            btnDone.setTitle("追加", for: .normal)
            lbTitleHeader.text = "ユーザー追加"
            txtFieldWeight.setTextDefault(text: "0")
            txtFieldHeight.setTextDefault(text: "0")
            
            dateSelected = NSDate() as Date?
        }
    }
}
