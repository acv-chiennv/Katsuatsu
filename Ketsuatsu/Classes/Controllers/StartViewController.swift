//
//  StartViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/13/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func invokedStart(_ sender: Any) {
        
    }
    
    @IBAction func invokedEditUser(_ sender: Any) {
        let editVC = UIUtils.viewControllerWithIndentifier(identifier: EDIT_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! AddUserViewController
        user.nickname = "chien"
        user.birthday = "1992/02/11"
        user.gender = GENDER_MALE
        user.weight = "65"
        user.height = "170"
        editVC.user = user
        editVC.isEdit = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func invokedGotoHistoryUser(_ sender: Any) {
        
    }
}
