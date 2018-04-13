//
//  ListUserViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class ListUserViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let USER_CELL_NIBNAME                 = "UserTableViewCell"
    let USER_CELL_IDENTIFIER              = "UserTableViewCell"
    
    
    let HEIGHT_ROW_DEFAULT = 85
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFile()
    }
    
    @IBAction func invokedAdd(_ sender: Any) {
        
    }
}

extension ListUserViewController {
    func registerNibFile() -> Void {
        tableView.register(UINib.init(nibName: USER_CELL_NIBNAME, bundle: nil), forCellReuseIdentifier: USER_CELL_IDENTIFIER)
        tableView.separatorStyle = .none
    }
}

extension ListUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USER_CELL_IDENTIFIER) as! UserTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_ROW_DEFAULT)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startVC = UIUtils.viewControllerWithIndentifier(identifier: START_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! StartViewController
        self.navigationController?.pushViewController(startVC, animated: true)
    }
}
