//
//  User.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/13/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var id: Int?
    var avatar: String?
    var nickname: String?
    var birthday: String?
    var gender: String?
    var weight: String?
    var height: String?
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        if let id = aDecoder.decodeObject(forKey: KEY_ID) as? Int {
            self.id = id
        }
        
        if let avatar = aDecoder.decodeObject(forKey: KEY_AVATAR) as? String {
            self.avatar = avatar
        }
        
        if let nickname = aDecoder.decodeObject(forKey: KEY_NICKNAME) as? String {
            self.nickname = nickname
        }
        
        if let birthday = aDecoder.decodeObject(forKey: KEY_BIRTHDAY) as? String {
            self.birthday = birthday
        }
        
        if let gender = aDecoder.decodeObject(forKey: KEY_GENDER) as? String {
            self.gender = gender
        }
        
        if let weight = aDecoder.decodeObject(forKey: KEY_WEIGHT) as? String {
            self.weight = weight
        }
        
        if let height = aDecoder.decodeObject(forKey: KEY_HEIGHT) as? String {
            self.height = height
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: KEY_ID)
        aCoder.encode(self.avatar, forKey: KEY_AVATAR)
        aCoder.encode(self.nickname, forKey: KEY_NICKNAME)
        aCoder.encode(self.birthday, forKey: KEY_BIRTHDAY)
        aCoder.encode(self.gender, forKey: KEY_GENDER)
        aCoder.encode(self.weight, forKey: KEY_WEIGHT)
        aCoder.encode(self.height, forKey: KEY_HEIGHT)
    }
}
