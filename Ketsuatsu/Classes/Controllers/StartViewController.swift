//
//  StartViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/13/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var userExist = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func invokedStart(_ sender: Any) {
        let getPresureVC = UIUtils.viewControllerWithIndentifier(identifier: GET_PREASURE_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! GetValuePresureViewController
        getPresureVC.user = userExist
        self.navigationController?.pushViewController(getPresureVC, animated: true)
    }
    
    @IBAction func invokedEditUser(_ sender: Any) {
        let editVC = UIUtils.viewControllerWithIndentifier(identifier: EDIT_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! AddUserViewController
        editVC.user = userExist
        editVC.isEdit = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func invokedGotoHistoryUser(_ sender: Any) {
        let historyVC = UIUtils.viewControllerWithIndentifier(identifier: HISTORY_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! HistoryMeasureViewController
        historyVC.user = userExist
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
}
