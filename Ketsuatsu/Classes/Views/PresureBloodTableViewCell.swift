//
//  PresureBloodTableViewCell.swift
//  Ketsuatsu
//
//  Created by ChuoiChien on 4/22/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

protocol DeletePresure {
    func deletePresure(_ index: Int) -> Void
}

class PresureBloodTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var deleteDelegate: DeletePresure?
    var indexCell: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(_ presure: PresureBlood) -> Void {
        let dateString = UIUtils.getStringFromDate(presure.createdAt, formatDate: "yyyy/MM/dd")
        date.text = UIUtils.convertStringDateToJapanFormat(dateString)
        
        let timeString = UIUtils.getStringFromDate(presure.createdAt, formatDate: "yyyy-MM-dd HH:mm:ss")
        let timeCreate = UIUtils.convertDateStringBetweenFormat(timeString, fromFormater: "yyyy-MM-dd HH:mm:ss", toFormater: "HH:mm")
        time.text = timeCreate
        value.text = String(presure.diastolic) + "/" + String(presure.systolic) + " mmHg"
    }
    
    @IBAction func invokedDelete(_ sender: Any) {
         deleteDelegate?.deletePresure(indexCell!)
    }
}
