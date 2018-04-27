//
//  ListUserViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import RealmSwift

class ListUserViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let USER_CELL_NIBNAME                 = "UserTableViewCell"
    let USER_CELL_IDENTIFIER              = "UserTableViewCell"
    
    let HEIGHT_ROW_DEFAULT = 85
    
    var listUser: Results<User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromDataBase()
    }
}

extension ListUserViewController {
    func registerNibFile() -> Void {
        tableView.register(UINib.init(nibName: USER_CELL_NIBNAME, bundle: nil), forCellReuseIdentifier: USER_CELL_IDENTIFIER)
        tableView.separatorStyle = .none
    }
    
    func getDataFromDataBase() -> Void {
        listUser = DataStore.sharedInstance.filterUserByCreateDate()
        tableView.reloadData()
    }
}

extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USER_CELL_IDENTIFIER) as! UserTableViewCell
        if listUser.count > 0 {
            let user = listUser[indexPath.row]
            cell.deleteDelegate = self
            cell.editDelegate = self
            cell.indexCell = indexPath.row
            cell.configUICell(user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_ROW_DEFAULT)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startVC = UIUtils.viewControllerWithIndentifier(identifier: START_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! StartViewController
        let user = listUser[indexPath.row]
        startVC.userExist = user
        self.navigationController?.pushViewController(startVC, animated: true)
    }
}

extension ListUserViewController: DeleteUser {
    func deleteUser(_ index: Int) {
        CustomAlertViewController.create()
            .setMessage(message: MESSAGE_CONFIRM_DELETE_USER)
            .setIsOneButton(isOne: false)
            .setTitleOk(title: "削除")
            .setbtnOKClicked(btnOKClicked: {
                let userRealmDelete = self.listUser[index]
                DataStore.sharedInstance.deleteUser(userRealmDelete)
                self.getDataFromDataBase()
            })
            .show()
    }
}

extension ListUserViewController: EditUser {
    func editUser(_ index: Int) {
        let editVC = UIUtils.viewControllerWithIndentifier(identifier: EDIT_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! AddUserViewController
        editVC.user = listUser[index]
        editVC.isEdit = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
