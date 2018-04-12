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

    @IBOutlet weak var lbBirthday: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldWeight: UITextField!
    @IBOutlet weak var txtFieldHeight: UITextField!
    
    var actionSheet: ActionSheetDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet?.maximumDate = Date()
        self.lbGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseGender)))
        lbGender.isUserInteractionEnabled = true
        setupUITextField()
    }
    
    @IBAction func invokedButtonCalendar(_ sender: Any) {
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate:(NSDate() as Date?) , minimumDate: nil, maximumDate: NSDate() as Date?, doneBlock: { (picker, value, index) in
            let date = value as? Date
            let dateString = UIUtils.getStringFromDate(date!, formatDate: "yyyy/MM/dd")
            self.lbBirthday.text = dateString
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
}

extension AddUserViewController {
    @objc func handleChooseGender(_ gesture: UITapGestureRecognizer) {
        ActionSheetStringPicker.show(withTitle: "", rows: ["男性", "女性"], initialSelection: 0, doneBlock: { (picker, index, value) in
            let stringGender = value as? String
            self.lbGender.text = stringGender
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
    
    func setupUITextField() -> Void {
        txtFieldName.limitCount(limit: 30)
        txtFieldWeight.limitCount(limit: 3)
        txtFieldWeight.setTextDefault(text: "0")
        txtFieldHeight.limitCount(limit: 3)
        txtFieldHeight.setTextDefault(text: "0")
    }
}
