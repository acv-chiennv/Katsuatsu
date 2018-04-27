//
//  PresureBlood.swift
//  Ketsuatsu
//
//  Created by ChuoiChien on 4/22/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import RealmSwift

class PresureBlood: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var userID: Int = 0
    @objc dynamic var systolic: Int = 0
    @objc dynamic var diastolic: Int = 0
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
