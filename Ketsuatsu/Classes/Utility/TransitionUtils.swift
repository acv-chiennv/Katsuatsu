//
//  TransitionUtils.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class DismissSegue : UIStoryboardSegue {
    override func perform() {
        source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

class PopSegue : UIStoryboardSegue {
    override func perform() {
        source.navigationController?.popViewController(animated: true)
    }
}
