//
//  UIUtils.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class UIUtils: NSObject {
    class func getStringFromDate(_ date: Foundation.Date, formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
}
