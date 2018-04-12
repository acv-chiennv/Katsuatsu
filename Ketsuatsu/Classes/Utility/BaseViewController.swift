//
//  BaseViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import IQKeyboardManager

class BaseViewController: UIViewController {
    let keyboardManager = KeyboardManager.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.onDestroy()
    }
}

extension BaseViewController {
    func addTapGesture() -> Void {
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
    }
}
