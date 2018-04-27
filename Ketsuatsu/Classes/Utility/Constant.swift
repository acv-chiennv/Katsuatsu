//
//  Constant.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

// KEY
let KEY_ID                  = "id"

let KEY_AVATAR              = "avatar"

let KEY_NICKNAME            = "nickname"

let KEY_BIRTHDAY            = "birthday"

let KEY_AGE                 = "age"

let KEY_GENDER              = "gender"

let KEY_WEIGHT              = "weight"

let KEY_HEIGHT              = "height"

let GENDER_MALE             = "男性"
let GENDER_FAMALE           = "女性"
let IMAGE_USER_DEFAULT      = "avatarDefault"

// CONTROLLER IDENTIFIER
let START_VIEWCONTROLLER_IDENTIFIER         = "StartViewController"
let EDIT_VIEWCONTROLLER_IDENTIFIER          = "AddUserViewController"
let HISTORY_VIEWCONTROLLER_IDENTIFIER       = "HistoryMeasureViewController"
let GET_PREASURE_VIEWCONTROLLER_IDENTIFIER  = "GetValuePresureViewController"
let IMAGE_LIBRARY_VIEWCONTROLLER_IDENTIFIER        = "SelectImageLibraryViewController"

// SEGUE IDENTIFIER
let LISTUSER_TO_START_SEGUE_IDENTIFIER  = "listUser_to_start_segue_id"

let WIDTH_DEVICE = UIScreen.main.bounds.size.width
let HEIGHT_DEVICE = UIScreen.main.bounds.size.height

let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

let IS_IPHONE_X = max(WIDTH_DEVICE, HEIGHT_DEVICE) == 812 && IS_IPHONE
let IS_IPHONE_4 = max(WIDTH_DEVICE, HEIGHT_DEVICE) < 568 && IS_IPHONE
let IS_IPHONE_5 = max(WIDTH_DEVICE, HEIGHT_DEVICE) == 568 && IS_IPHONE
let IS_IPHONE_6 = max(WIDTH_DEVICE, HEIGHT_DEVICE) == 667 && IS_IPHONE
let IS_IPHONE_6_PLUS = max(WIDTH_DEVICE, HEIGHT_DEVICE) == 736 && IS_IPHONE

struct FONT_DESCRIPTION_NAME {
    static let FONT_DESCRIPTION_YU_GOTHIC_BOLD = "YuGothic Bold"
    static let FONT_DESCRIPTION_YU_GOTHIC_MEDIUM = "YuGothic Medium"
}

let MESSAGE_CONFIRM_DELETE_USER     = "ユーザーを削除すると、\n 測定履歴が全てなくなりますので、\n よろしいでしょうか？"
let HEIGHT_ALERT_ERROR = CGFloat(120)

enum ERROR_INPUT: Int {
    case INPUT_NAME
    case INPUT_BIRTHDAY
    case INPUT_GENDER
    case INPUT_WEIGHT
    case INPUT_HEIGHT
    
    func isShowErrorMessage(_ errorCode: ERROR_INPUT) -> String {
        switch self {
        case .INPUT_NAME:
            return "データがありません"
        case .INPUT_BIRTHDAY:
            return "データがありません"
        case .INPUT_GENDER:
            return "データがありません"
        case .INPUT_WEIGHT:
            return "データがありません"
        case .INPUT_HEIGHT:
            return "データがありません"
        }
    }
}
