//
//  UserTableViewCell.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/9/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

protocol DeleteUser {
    func deleteUser(_ index: Int) -> Void
}

protocol EditUser {
    func editUser(_ index: Int) -> Void
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    
    var deleteDelegate: DeleteUser?
    var editDelegate: EditUser?
    var indexCell: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func invokedEdit(_ sender: Any) {
        editDelegate?.editUser(indexCell!)
    }
    
    @IBAction func invokedDelete(_ sender: Any) {
        deleteDelegate?.deleteUser(indexCell!)
    }
    
    func configUICell(_ user: User) -> Void {
        avatarImage.layer.cornerRadius = avatarImage.bounds.size.width / 2.0
        avatarImage.clipsToBounds = true
        
        if user.avatar != nil {
            self.avatarImage.image = UIImage(data: user.avatar!)
        } else {
            avatarImage.image = UIImage(named: IMAGE_USER_DEFAULT)
        }
        name.text = user.nickname
        if user.age != 0 {
            age.text = String(user.age) + "歳"
        }
    }
}
