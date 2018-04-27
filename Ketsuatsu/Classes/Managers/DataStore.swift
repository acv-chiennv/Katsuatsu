//
//  DataStore.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/17/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import RealmSwift

class DataStore {
    
    static let sharedInstance = DataStore()
    let realm:Realm
    
    
    init() {
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        
        #if DEBUG
            realm = try! Realm()
        #else
            realm = try! Realm()
            /*
             let key = DataStore.getKey()
             LogDebug("====> DB Encryp key:\(key)")
             // Open the encrypted Realm file
             let config = Realm.Configuration(encryptionKey: key)
             do {
             realm = try Realm(configuration: config)
             // Use the Realm as normal
             } catch let error as NSError {
             // If the encryption key is wrong, `error` will say that it's an invalid database
             fatalError("Error opening realm: \(error)")
             }
             */
        #endif
        debugPrint("Realm Path: ====\n\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))\"\n======")
    }
    //MARK: clear DB
    func clearDB() {
        try! realm.write({
            realm.deleteAll();
        })
    }
}

extension DataStore {
    
    // Todo User Object
    func incrementUserID() -> Int {
        return (realm.objects(User.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func addUser(_ user: User) -> Void {
        try! realm.write({
            realm.add(user, update: false)
        })
    }
    
    func editUser(_ user: User) -> Void {
        try! realm.write({
            realm.add(user, update: true)
        })
    }
    
    func deleteUser(_ user: User) -> Void {
        let listPresureBlood: Results<PresureBlood> = realm.objects(PresureBlood.self).filter("userID = %@", user.id)
        try! realm.write({
            realm.delete(user)
            realm.delete(listPresureBlood)
        })
    }

    func getAllUser() -> Results<User> {
        let listUser: Results<User>? = realm.objects(User.self)
        return listUser!
    }
    
    func filterUserByCreateDate() -> Results<User> {
        let listUser: Results<User>? = realm.objects(User.self).sorted(byKeyPath: "createdAt", ascending: false)
        return listUser!
    }
    
    // Todo PresureBlood Object
    func incrementPresureBloodID() -> Int {
        return (realm.objects(PresureBlood.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func addPresureBlood(_ object: PresureBlood) -> Void {
        try! realm.write({
            realm.add(object, update: false)
        })
    }
    
    func deletePresureBlood(_ object: PresureBlood) -> Void {
        try! realm.write({
            realm.delete(object)
        })
    }
    
    func getAllPresureBloodOfUser(_ userID: Int) -> Results<PresureBlood> {
        let listPresureBlood: Results<PresureBlood>? = realm.objects(PresureBlood.self).filter("userID = %@", userID).sorted(byKeyPath: "createdAt", ascending: false)
        return listPresureBlood!
    }
    
    func filterPresureBloodOfUserID(_ userID: Int, _ startDate: Date, _ endDate: Date) -> Results<PresureBlood> {
        let listData = realm.objects(PresureBlood.self).filter("userID = %@ AND createdAt BETWEEN {%@, %@}", userID, startDate, endDate).sorted(byKeyPath: "createdAt", ascending: false)
        
        return listData
    }
}
