//
//  User.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/13/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var avatar: Data?
    @objc dynamic var nickname = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var birthday = Date()
    @objc dynamic var gender: Int = 0
    @objc dynamic var weight: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
