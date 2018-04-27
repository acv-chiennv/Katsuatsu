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
    
    class func convertDateStringBetweenFormat(_ dateString: String, fromFormater: String, toFormater: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormater
        guard let date = dateFormatter.date(from: dateString) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = toFormater
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
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
    
    // Convert format YYYY/MM/DD -> YYYY年MM月DD日
    class func convertStringDateToJapanFormat(_ string: String) -> String {
        let ageComponents = string.components(separatedBy: "/")
        return ageComponents[0] + "年" + ageComponents[1] + "月" + ageComponents[2] + "日"
    }
    
    // Caculator Age From Date of birthday format YYYY/MM/DD
    class func caculatorAgeFromBirthDay(_ birthDayString: String) -> Int {
        let ageComponents = birthDayString.components(separatedBy: "/")
    
        let dateDOB = Calendar.current.date(from: DateComponents(year:
        Int(ageComponents[0]), month: Int(ageComponents[1]), day:
        Int(ageComponents[2])))!
    
        return dateDOB.age
    }
    
    static func fontLineSpacing(_ label : UILabel, lineSpacing : CGFloat) {
        
        let dText : String = label.text!
        let fontName = label.font.fontName
        let fontSize = label.font.pointSize
        
        let dStyle = NSMutableParagraphStyle()
        dStyle.lineSpacing = lineSpacing
        dStyle.alignment = label.textAlignment
        let dFontAttribute = [ kCTFontAttributeName: UIFont(name: fontName, size: fontSize)! ]
        let dAttributeString = NSMutableAttributedString(string: dText, attributes: dFontAttribute as [NSAttributedStringKey : Any])
        
        dAttributeString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value: dStyle, range: NSMakeRange(0, dText.count))
        label.attributedText = dAttributeString
    }
    
    // ToDo UserDefault
    class func storeObjectToUserDefault(_ object: AnyObject, key: String) {
        let dataSave = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(dataSave, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getObjectFromUserDefault(_ key: String) -> AnyObject? {
        if let object = UserDefaults.standard.object(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: object as! Data) as AnyObject?
        }
        
        return nil
    }
    
    class func removeObjectForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Base 64
    class func getBase64StringFromImageURL(_ strUrl: String) -> String? {
        guard let url = URL(string: strUrl) else {
            return nil
        }
        guard let imageData = NSData(contentsOf: url) else {
            return nil
        }
        return imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    class func base64ToUIImage(_ stringBase64: String) -> UIImage? {
        if let data = Data(base64Encoded: stringBase64) {
            return UIImage(data: data)
        }
        return nil
    }
}
