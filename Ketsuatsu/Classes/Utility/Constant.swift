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

let KEY_GENDER              = "gender"

let KEY_WEIGHT              = "weight"

let KEY_HEIGHT              = "height"

let GENDER_MALE             = "男性"

let GENDER_FAMALE           = "女性"

// CONTROLLER IDENTIFIER
let START_VIEWCONTROLLER_IDENTIFIER     = "StartViewController"
let EDIT_VIEWCONTROLLER_IDENTIFIER      = "AddUserViewController"
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
