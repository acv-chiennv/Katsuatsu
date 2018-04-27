//
//  GetValuePresureViewController.swift
//  Ketsuatsu
//
//  Created by ChuoiChien on 4/22/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class GetValuePresureViewController: BaseViewController {
    
    @IBOutlet weak var viewGraph: ViewGraph!
    var user = User()
    var dateSelected = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewGraph.drawGraph(125, 80, isEnd: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewGraph.drawGraph(150, 90, isEnd: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewGraph.drawGraph(120, 85, isEnd: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewGraph.drawGraph(175, 75, isEnd: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.viewGraph.drawGraph(135, 80, isEnd: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.viewGraph.drawGraph(160, 95, isEnd: true)
        }
    }
}
