//
//  UIUtils.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class UIUtils: NSObject {
    
    // get ViewController
    class func viewControllerWithIndentifier(identifier: String, storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    // Format Date
    class func getStringFromDate(_ date: Foundation.Date, formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
    class func getDateFromString(_ date: String, formatDate: String) -> Foundation.Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = formatDate
        return dateFormatter.date(from: date)!
    }
    
    // Handle String
    class func removeFirstCharacterIsZero(_ numberString: String) -> String {
        var newString = numberString
        while newString.first == "0" {
            let index = newString.index(newString.startIndex, offsetBy: 1)
            newString = String(newString[index...])
        }
        return newString
    }
}
