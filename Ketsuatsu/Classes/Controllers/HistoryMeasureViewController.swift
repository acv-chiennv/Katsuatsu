//
//  HistoryMeasureViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/19/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import RealmSwift

class HistoryMeasureViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lbEndDate: UILabel!
    
    let PRESURE_CELL_NIBNAME                 = "PresureBloodTableViewCell"
    let PRESURE_CELL_IDENTIFIER              = "PresureBloodTableViewCell"
    
    let HEIGHT_ROW_DEFAULT = 85
    
    var user = User()
    var listPresure: Results<PresureBlood>!
    var startDateSelected: Date?
    var endDateSelected: Date?
    var actionSheet: ActionSheetDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
        setupUI()
        getDataFromDataBase(isFilter: false)
    }
    
    @IBAction func invokedSearch(_ sender: Any) {
        if lbStartDate.text == "" || lbEndDate.text == "" {
            return
        }
        getDataFromDataBase(isFilter: true)
    }
    
    @IBAction func invokedButtonStartDate(_ sender: Any) {
        if startDateSelected == nil {
            startDateSelected = Date()
        }
        if endDateSelected == nil {
            endDateSelected = Date()
        }
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .dateAndTime, selectedDate:startDateSelected , minimumDate: nil, maximumDate: endDateSelected, doneBlock: { (picker, value, index) in
            let date = value as? Date
            self.startDateSelected = value as? Date
            let dateString = UIUtils.getStringFromDate(date!, formatDate: "yyyy/MM/dd")
            self.lbStartDate.text = UIUtils.convertStringDateToJapanFormat(dateString)
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
    
    @IBAction func invokedButtonEndDate(_ sender: Any) {
        if endDateSelected == nil {
            endDateSelected = Date()
        }
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .dateAndTime, selectedDate:endDateSelected , minimumDate: startDateSelected, maximumDate: Date(), doneBlock: { (picker, value, index) in
            let date = value as? Date
            self.endDateSelected = value as? Date
            let dateString = UIUtils.getStringFromDate(date!, formatDate: "yyyy/MM/dd")
            self.lbEndDate.text = UIUtils.convertStringDateToJapanFormat(dateString)
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
}

extension HistoryMeasureViewController {
    func registerNibFile() -> Void {
        tableView.register(UINib.init(nibName: PRESURE_CELL_NIBNAME, bundle: nil), forCellReuseIdentifier: PRESURE_CELL_IDENTIFIER)
        tableView.separatorStyle = .none
    }
    
    func setupUI() -> Void {
        lbStartDate.font =  UIFont(descriptor: UIFontDescriptor(name: FONT_DESCRIPTION_NAME.FONT_DESCRIPTION_YU_GOTHIC_MEDIUM, size: IS_IPHONE_5 ? 11 : 13), size: IS_IPHONE_5 ? 11 : 13)
        lbEndDate.font =  UIFont(descriptor: UIFontDescriptor(name: FONT_DESCRIPTION_NAME.FONT_DESCRIPTION_YU_GOTHIC_MEDIUM, size: IS_IPHONE_5 ? 11 : 13), size: IS_IPHONE_5 ? 11 : 13)
    }
    
    func getDataFromDataBase(isFilter: Bool) -> Void {
        listPresure = DataStore.sharedInstance.getAllPresureBloodOfUser(user.id)
        if isFilter {
            listPresure = DataStore.sharedInstance.filterPresureBloodOfUserID(user.id, startDateSelected!, endDateSelected!)
        }
        tableView.reloadData()
    }
}

extension HistoryMeasureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPresure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PRESURE_CELL_IDENTIFIER) as! PresureBloodTableViewCell
        if listPresure.count > 0 {
            let presure = listPresure[indexPath.row]
            cell.deleteDelegate = self
            cell.indexCell = indexPath.row
            cell.configUI(presure)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_ROW_DEFAULT)
    }
}

extension HistoryMeasureViewController: DeletePresure {
    func deletePresure(_ index: Int) {
        CustomAlertViewController.create()
            .setMessage(message: MESSAGE_CONFIRM_DELETE_USER)
            .setIsOneButton(isOne: false)
            .setTitleOk(title: "削除")
            .setbtnOKClicked(btnOKClicked: {
                let objectRealmDelete = self.listPresure[index]
                DataStore.sharedInstance.deletePresureBlood(objectRealmDelete)
                if (self.lbStartDate.text != "" && self.lbEndDate.text != "") {
                    self.getDataFromDataBase(isFilter: true)
                } else {
                    self.getDataFromDataBase(isFilter: false)
                }
            })
            .show()
    }
}
